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
    var income: Int = 0
    var multiple: Int = 1
    var time: Double = 0
    var open = false
    var isOperation = false
    var hasManager = false
    
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
            income = (index + 1) * Int(pow(2, Double(index))) * multiple
            
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
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerAction), userInfo: nil, repeats: true)
        }
    }
}

// MARK: - Private Methods
extension StoreModel {
    @objc
    fileprivate func updateTimerAction() {
        time += 0.1
        if time >= Double(interval) {
            isOperation = false
            StoreManager.shared.increaseTotaleIncome(income: income)
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
                resetCache()
            }
        }
    }
    
    fileprivate func resetCache() {
        time = 0
    }
}
