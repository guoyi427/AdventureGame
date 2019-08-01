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
    var totalIncome = 0
    weak var delegate: StoreManagerDelegate?
    
    fileprivate var list: [StoreModel] = []
    
    override init() {
        super.init()
        prepareData()
    }
    
    /// 根据下标获取商店模型
    ///
    /// - Parameter index: 下标
    /// - Returns: 商店模型
    func getModel(index: Int) -> StoreModel {
        if index <= MaxStoreIndex {
            return list[index]
        }
        return list[MaxStoreIndex]
    }
    
    /// 增加总收入
    ///
    /// - Parameter income: 待增加收入
    func increaseTotaleIncome(income: Int) {
        totalIncome += income
        /// 更新收入之后 通过代理把总收入更新给UI
        if let delegate = delegate {
            delegate.didUpdateTotalIncome(income: totalIncome)
        }
    }
}

// MARK: - Private Methods
extension StoreManager {
    fileprivate func prepareData() {
        for x in 0...MaxStoreIndex {
            let model = StoreModel(index: x)
            list.append(model)
        }
    }
    
    @objc
    fileprivate func update() {
        
    }
}

/// 代理
protocol StoreManagerDelegate: NSObject {
    /// 总收入更新
    ///
    /// - Parameter income: 总收入
    func didUpdateTotalIncome(income: Int)
}
