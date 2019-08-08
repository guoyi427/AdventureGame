//
//  StoreModel.swift
//  AdventureGame
//
//  Created by Gray on 7/31/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

/// 名字列表
let NameList = ["Lemoned", "Newspaper", "Car", "Donut", "Seafood", "Sport", "Movie", "Government", "Oil"]
fileprivate let AvatarList = [#imageLiteral(resourceName: "lemon"), #imageLiteral(resourceName: "newspaper"), #imageLiteral(resourceName: "car"), #imageLiteral(resourceName: "donut"), #imageLiteral(resourceName: "seafood"), #imageLiteral(resourceName: "sport"), #imageLiteral(resourceName: "movie"), #imageLiteral(resourceName: "government"), #imageLiteral(resourceName: "oil")]
/// 最大下标
let MaxStoreIndex = 8

class StoreModel: NSObject {
    /// 商店名称
    var name = ""
    /// 商店头像
    var avatarImage = #imageLiteral(resourceName: "lemon")
    /// id
    var sid = 0
    /// 等级
    var level: Int = 0
    /// 当前执行间隔（影响因素包含 等级、加速倍数）
    var interval: Double = 0
    /// 原始执行间隔
    var originalInterval: Double = 0
    /// 当前收益（影响因素包含 等级、加速倍数）
    var income: MoneyUnit = MoneyUnit.zero
    /// 原始收益
    var originalIncome: MoneyUnit = MoneyUnit.zero
    /// 收益加速倍数
    var multiple: Double = 1
    /// 当前执行时间
    var time: Double = 0
    /// 是否被解锁
    var isUnlock = false
    /// 是否正在执行
    var isOperation = false
    /// 结束后是否自动执行下一次
    var hasManager = true
    /// 升级需要的金币
    var upgradeMoney: MoneyUnit = MoneyUnit.zero
    /// 解锁需要的金币
    var unlockMoney: MoneyUnit = MoneyUnit.zero
    
    
    weak var view: StoreView?
    
    fileprivate var timer: Timer?
    
    override var description: String {
        return "name:\(name), level:\(level), interval:\(interval), income:\(income.text()), time:\(time)"
    }
    
    
    init(index: Int) {
        super.init()
        if index <= MaxStoreIndex {
            name = NameList[index]
            avatarImage = AvatarList[index]
            sid = index
            level = 1
            interval = 5 * pow(2, Double(index))
            originalInterval = interval
            income = MoneyUnit.creatIncome(income: Double(index + 1) * pow(2, Double(index)) * multiple)
            originalIncome = income
            //  如果是第一个店铺 默认解锁
            isUnlock = index == 0
            unlockMoney = originalIncome
            calculateUpgradeNeedMoney()
        }
    }
    
    override init() {
        super.init()
    }
    
    /// 执行
    func operation() {
        if isOperation {
            return
        }
        
        isOperation = true
        
        if timer == nil {
            timer = Timer(timeInterval: 0.1, target: self, selector: #selector(updateTimerAction), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    /// 升级
    func upgrade() {
        //  升级需要消耗的钱
        calculateUpgradeNeedMoney()
        //  如果金额不足弹窗提示用户
        if StoreManager.shared.totalIncome < upgradeMoney {
            let alert = UIAlertController(title: "金额不足", message: "升级到\(level+1)级需要\(upgradeMoney.text())金币", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        //  总收入减少
        StoreManager.shared.changeTotaleIncome(income: -upgradeMoney)
        
        //  更新升级数据
        upgradeRefresh()
        
        //  更新UI
        if let view = view {
            view.update(model: self)
        }
    }
    
    /// 解锁商店
    func unlockStore() {
        if isUnlock {
            return
        }
        
        if StoreManager.shared.totalIncome >= unlockMoney {
            isUnlock = true
            StoreManager.shared.changeTotaleIncome(income: -unlockMoney)
        } else {
            //  钱不够
            let alert = UIAlertController(title: "金额不足", message: "解锁\(name)需要\(unlockMoney.text())金币", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Private Methods
extension StoreModel {
    @objc
    fileprivate func updateTimerAction() {
        //  更新进度，并更新UI
        time += 0.1
        if let view = view {
            //  升级需要消耗的钱    如果攒够钱 view需要更新按钮状态
            calculateUpgradeNeedMoney()
            view.update(model: self)
        }
        
        //  判断是否结束
        if time >= interval {
            isOperation = false
            //  结束一轮 增加总收入
            StoreManager.shared.changeTotaleIncome(income: income)
            //  判断是否有管理员，自动执行下一次
            if hasManager {
                resetCache()
                return
            }
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
                resetCache()
            }
        }
    }
    
    /// 恢复执行前状态
    fileprivate func resetCache() {
        time = 0
    }
    
    /// 升级更新数据
    fileprivate func upgradeRefresh() {
        level += 1
        income = originalIncome * MoneyUnit.creatIncome(income: pow(2, Double(level - 1)))
        let intervalMutiple = 1 / (pow(Double(level / 10), 2) + 1)
        interval = Double(originalInterval) * intervalMutiple
    }
    
    /// 计算升级所需金币
    fileprivate func calculateUpgradeNeedMoney() {
        upgradeMoney = income * MoneyUnit.creatIncome(income: pow(1.2, Double(level)))
    }
}
