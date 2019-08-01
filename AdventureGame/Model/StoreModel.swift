//
//  StoreModel.swift
//  AdventureGame
//
//  Created by Gray on 7/31/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

fileprivate let NameList = ["Lemoned", "Bar", "Car", "Bank", "Banana", "Oil", "House", "Girls", "Boys", "Killer", "Cleaner"]
/// 最大下标
let MaxStoreIndex = 10

class StoreModel: NSObject {
    var name = ""
    var avatarImage = #imageLiteral(resourceName: "avatar")
    var level: Int = 0
    var interval: Int = 0
    var originalInterval: Int = 0
    var income: Int = 0
    var originalIncome: Int = 0
    var multiple: Int = 1
    var time: Double = 0
    var open = false
    var isOperation = false
    var hasManager = false
    
    weak var view: StoreView?
    
    fileprivate var timer: Timer?
    
    override var description: String {
        return "name:\(name), level:\(level), interval:\(interval), income:\(income), time:\(time)"
    }
    
    
    init(index: Int) {
        super.init()
        if index <= MaxStoreIndex {
            name = NameList[index]
            level = 1
            interval = 5 * Int(pow(2, Double(index)))
            originalInterval = interval
            income = (index + 1) * Int(pow(2, Double(index))) * multiple
            originalIncome = income
        }
    }
    
    /// 执行
    func operation() {
        if isOperation {
            return
        }
        
        isOperation = true
        
        if let timer = timer {
            timer.invalidate()
        } else {
            timer = Timer(timeInterval: 0.1, target: self, selector: #selector(updateTimerAction), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    /// 升级
    func upgrade() {
        //  升级需要消耗的钱
        let needMoney = income * Int(pow(1.2, Double(level)))
        print("upgrade need money = \(needMoney)")
        if StoreManager.shared.totalIncome < needMoney {
            let alert = UIAlertController(title: "金额不足", message: "升级到\(level+1)级需要\(needMoney)金币", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        StoreManager.shared.changeTotaleIncome(income: -needMoney)
        
        //  更新升级数据
        upgradeRefresh()
        
        //  更新UI
        if let view = view {
            view.update(model: self)
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
            view.update(model: self)
        }
        
        if time >= Double(interval) {
            isOperation = false
            //  结束一轮 增加总收入
            StoreManager.shared.changeTotaleIncome(income: income)
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
        income = originalIncome * level
        let intervalMutiple = 1 / (pow(Double(level / 10), 2) + 1)
        interval = Int(Double(originalInterval) * intervalMutiple)
    }
}
