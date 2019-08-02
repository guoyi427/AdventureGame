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
    var totalIncome = 10000000000
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
    func changeTotaleIncome(income: Int) {
        totalIncome += income
        /// 更新收入之后 通过代理把总收入更新给UI
        if let delegate = delegate {
            delegate.didUpdateTotalIncome(income: totalIncome)
        }
    }
}

// MARK: - Private Methods
extension StoreManager {
    /// 准备数据
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
