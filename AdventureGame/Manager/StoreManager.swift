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
    var multiple = 1
    var circle = 1
    var diamonds = 0
    var leaveTime = 0
    
    
    
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
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let gameController = appdelegate.gameController else { return }
        if leaveTime > 0 {
            let currentTimestamp = Date.init().timeIntervalSince1970
            let differTime = currentTimestamp - TimeInterval(leaveTime)
            let backgroundIncome = calculateAverageIncomePerSeconds() * differTime
            let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
                self.changeTotaleIncome(income: backgroundIncome)
            }
            let alertController = UIAlertController(title: "后台收入", message: "您在后台这段时间赚取了\(backgroundIncome.text())", preferredStyle: .alert)
            alertController.addAction(alertAction)
            gameController.present(alertController, animated: true, completion: nil)
        }
        
        //  刷新UI
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
        
//        let ips = totalIPS / Double(list.count)
        
        return totalIPS
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
}

/// 代理
protocol StoreManagerDelegate: NSObject {
    /// 总收入更新
    ///
    /// - Parameter income: 总收入
    func didUpdateTotalIncome(income: MoneyUnit)
}
