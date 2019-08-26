//
//  StoreManager.swift
//  AdventureGame
//
//  Created by Gray on 7/31/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

class StoreManager: NSObject {
    static let shared = StoreManager()
    
    /// 总收入
    var totalIncome: MoneyUnit = MoneyUnit.zero
    /// 总收入倍数
    var multiple: Double = 1
    /// 生命周期
    var circle = 1
    /// 总钻石数
    var diamonds = 0
    /// 上次离开时间
    var leaveTime = 0
    /// 催化剂结束时间
    var catalyzerEndTime: Double = 0
    
    
    
    weak var delegate: StoreManagerDelegate?
    
    var list: [StoreModel] = []
    
    override init() {
        super.init()
        prepareData()
    }
    
    /// 从数据库中准备商店数据
    func prepareListFromDB() {
        //  更新每个商店的数据
        let listFromDB = StoreDBManager.shared.queryStoreList()
        for x in 0...listFromDB.count - 1 {
            let modelFromDB = listFromDB[x]
            let model = list[x]
            if modelFromDB.sid == model.sid {
                model.level = modelFromDB.level
                model.interval = modelFromDB.interval
                model.originalInterval = modelFromDB.originalInterval
                model.income = modelFromDB.income
                model.originalIncome = modelFromDB.originalIncome
                model.multiple = modelFromDB.multiple
                model.time = modelFromDB.time
                model.isUnlock = modelFromDB.isUnlock
                model.isOperation = modelFromDB.isOperation
                model.hasManager = modelFromDB.hasManager
                model.upgradeMoney = modelFromDB.upgradeMoney
                model.unlockMoney = modelFromDB.unlockMoney
            }
        }
        //  更新总收入
        TotalDBManager.shared.queryTotalToShareManager()
        //  更新后台收入
        prepareBackgroundIncome()
        //  刷新UI
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let gameController = appdelegate.gameController else { return }
        gameController.uploadStoreView()
    }
    
    /// 根据下标获取商店模型
    ///
    /// - Parameter index: 下标
    /// - Returns: 商店模型
    func setupModel(index: Int, view: StoreView) {
        if index <= MaxStoreIndex {
            let model = list[index]
            model.view = view
            view.update(model: model)
        }
    }
    
    /// 增加或减少总收入
    ///
    /// - Parameter income: 待增加收入
    func changeTotaleIncome(income: MoneyUnit) {
        totalIncome += income
        
        //  计算进位
        totalIncome.lowerMultiple()
        
        /// 更新收入之后 通过代理把总收入更新给UI
        if let delegate = delegate {
            delegate.didUpdateTotalIncome(income: totalIncome)
        }
    }
    
    /// 计算每秒收入
    ///
    /// - Returns: 收入
    func calculateAverageIncomePerSeconds() -> MoneyUnit {
        var totalIPS: MoneyUnit = MoneyUnit(number: 0, multiple: 0)
        
        //  计算每个商店的 IPS--income per seconds
        for model in list {
            let storeIPS = model.income / model.interval
            if model.isUnlock {
                totalIPS += storeIPS
            }
        }
        
        return totalIPS * multiple
    }
}

// MARK: - Private Methods
extension StoreManager {
    /// 准备数据
    fileprivate func prepareData() {
        let listFromDB = StoreDBManager.shared.queryStoreList()
        if listFromDB.count > 0 {
            list.append(contentsOf: listFromDB)
        } else {
            for x in 0...MaxStoreIndex {
                let model = StoreModel(index: x)
                list.append(model)
            }
        }
    }
    
    /// 更新后台收入
    fileprivate func prepareBackgroundIncome() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let gameController = appdelegate.gameController else { return }
        if leaveTime > 0 {
            let currentTimestamp = Date.init().timeIntervalSince1970
            /// 后台时间
            let differTime = currentTimestamp - TimeInterval(leaveTime)
            //  如果后台时间太短，就不提示用户了
            if differTime < 60 {
                return
            }
            /// 后台收入 = 平均每小时收入 * 后台时间
            let backgroundIncome = calculateAverageIncomePerSeconds() * differTime
            /// 每连续后台一小时增加一枚钻石消耗
            var needDiamonds = Int(differTime / 3600)
            if needDiamonds == 0 {
                needDiamonds = 1
            }
            
            let cancelAction = UIAlertAction(title: "拒绝", style: .cancel, handler: nil)
            let diamondsAction = UIAlertAction(title: "消耗钻石", style: .default) { (action) in
                //  消耗钻石，将后台收入加入到总收入
                self.earnBackgroundIncomeByDiamonds(income: backgroundIncome, needDiamonds: needDiamonds)
            }
            let advertAction = UIAlertAction(title: "看广告", style: .default) { (action) in
                //  看广告
                self.earnBackgroundIncomeByAdvert(income: backgroundIncome)
            }
            let alertController = UIAlertController(title: "后台收入", message: "您在后台这段时间赚取了\(backgroundIncome.text())金币，可消耗\(needDiamonds)枚钻石或者点击一个广告获取后台收益", preferredStyle: .alert)
            alertController.addAction(diamondsAction)
            alertController.addAction(advertAction)
            alertController.addAction(cancelAction)
            gameController.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// 通过广告获取后台收益
    ///
    /// - Parameter income: 后台收入
    fileprivate func earnBackgroundIncomeByAdvert(income: MoneyUnit) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let gameController = appdelegate.gameController else { return }
        
        //  菊花
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        activityView.startAnimating()
        gameController.view.addSubview(activityView)
        
        AdsManager.instance.showInterstitial(viewController: gameController, complete: { [weak self] (result) in
            activityView.removeFromSuperview()
            if result {
                //  成功，把后台收入加到总收入
                self?.changeTotaleIncome(income: income)
                TotalDBManager.shared.saveTotal()
            } else {
                //  跳转广告失败
                let knowAction = UIAlertAction(title: "知道了", style: .default, handler: { (action) in
                    self?.prepareBackgroundIncome()
                })
                let notClickAlert = UIAlertController(title: "您没有点击广告", message: "请点击广告跳转再返回即可", preferredStyle: .alert)
                notClickAlert.addAction(knowAction)
                gameController.present(notClickAlert, animated: true, completion: nil)
            }
        })
    }
    
    /// 通过钻石获取后台收益
    ///
    /// - Parameters:
    ///   - income: 后台收益
    ///   - needDiamonds: 获取收益所需要的钻石
    fileprivate func earnBackgroundIncomeByDiamonds(income: MoneyUnit, needDiamonds: Int) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let gameController = appdelegate.gameController else { return }
        
        //  判断当前剩余钻石够不够
        if StoreManager.shared.diamonds >= needDiamonds {
            self.changeTotaleIncome(income: income)
            StoreManager.shared.diamonds -= needDiamonds
            TotalDBManager.shared.saveTotal()
            gameController.uploadStoreView()
        } else {
            //  钻石不够
            let knowAction = UIAlertAction(title: "知道了", style: .default, handler: { (action) in
                self.prepareBackgroundIncome()
            })
            let notClickAlert = UIAlertController(title: "您钻石不够啦", message: "请点击广告或者放弃后台收益", preferredStyle: .alert)
            notClickAlert.addAction(knowAction)
            gameController.present(notClickAlert, animated: true, completion: nil)
        }
    }
}

/// 代理
protocol StoreManagerDelegate: NSObject {
    /// 总收入更新
    ///
    /// - Parameter income: 总收入
    func didUpdateTotalIncome(income: MoneyUnit)
}
