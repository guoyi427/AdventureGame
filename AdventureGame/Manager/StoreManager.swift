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
        let listFromDB = StoreDBManager.shared.queryStoreList()
        if listFromDB.count > 0 {
            list.removeAll()
            list.append(contentsOf: listFromDB)
        }
        TotalDBManager.shared.queryTotalToShareManager()
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
            print(storeIPS)
            totalIPS += storeIPS
        }
        
        let ips = totalIPS / Double(list.count)
        
        return ips
    }
}

// MARK: - Private Methods
extension StoreManager {
    /// 准备数据
    fileprivate func prepareData() {
        list.removeAll()
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
