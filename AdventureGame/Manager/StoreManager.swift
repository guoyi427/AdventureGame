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
    dynamic var totalIncome = 0
    
    
    fileprivate var list: [StoreModel] = []
    
    override init() {
        super.init()
        prepareData()
    }
    
    func getModel(index: Int) -> StoreModel {
        if index <= MaxStoreIndex {
            return list[index]
        }
        return list[MaxStoreIndex]
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
