//
//  DBManager.swift
//  AdventureGame
//
//  Created by Gray on 8/7/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import Foundation
import SQLite3

class DBManager: NSObject {
    static let shared = DBManager()
    
    fileprivate var db: OpaquePointer?
    
    override init() {
        super.init()
        let path = Bundle.main.path(forResource: "AdventureGame", ofType: "db")
        let state = sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil)
        if state != SQLITE_OK {
            print("open db failed")
        }
        if let path = path {
            print("db path", path)
        }
    }
    
    func saveAllStore() {
        guard let db = db else { return }
        let sqlStr = "insert into Store (name, avatar_name, level, interval, original_interval, income_number, income_multiple, original_income_number, original_income_multiple, multiple, time, isUnlock, isOperation, hasManager, upgradeMoney_number, upgradeMoney_multiple, unlockMoney_number, unlockMoney_multiple) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        for model in StoreManager.shared.list {
            var statement: OpaquePointer?
            let result = sqlite3_prepare_v2(db, sqlStr, -1, &statement, nil)
            if result != SQLITE_OK {
                sqlite3_finalize(statement)
                print("insert store error")
            }
            
            sqlite3_bind_text(statement, 1, model.name, -1, nil)
            sqlite3_bind_text(statement, 2, model.name, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(model.level))
            sqlite3_bind_double(statement, 4, model.interval)
            sqlite3_bind_double(statement, 5, model.originalInterval)
            sqlite3_bind_double(statement, 6, model.income.number)
            sqlite3_bind_int(statement, 7, Int32(model.income.multiple))
            sqlite3_bind_double(statement, 8, model.originalIncome.number)
            sqlite3_bind_int(statement, 9, Int32(model.originalIncome.multiple))
            sqlite3_bind_double(statement, 10, model.multiple)
            sqlite3_bind_double(statement, 11, model.time)
            sqlite3_bind_int(statement, 12, model.isUnlock ? 1 : 0)
            sqlite3_bind_int(statement, 13, model.isOperation ? 1 : 0)
            sqlite3_bind_int(statement, 14, model.hasManager ? 1 : 0)
            sqlite3_bind_double(statement, 15, model.upgradeMoney.number)
            sqlite3_bind_int(statement, 16, Int32(model.upgradeMoney.multiple))
            sqlite3_bind_double(statement, 17, model.unlockMoney.number)
            sqlite3_bind_int(statement, 18, Int32(model.unlockMoney.multiple))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("insert store done")
            } else {
                print("insert store failed")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    func queryStoreList() -> [StoreModel] {
        var list: [StoreModel] = []
        
        guard let db = db else { return list}
        let sqlStr = "select * from Store"
        var statement: OpaquePointer?
        let result = sqlite3_prepare_v2(db, sqlStr, -1, &statement, nil)
        if result != SQLITE_OK {
            sqlite3_finalize(statement)
            return list
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let model = StoreModel()
            model.name = String(cString: sqlite3_column_text(statement, 1))
            model.level = Int(sqlite3_column_int(statement, 3))
            model.interval = sqlite3_column_double(statement, 4)
            model.originalInterval = sqlite3_column_double(statement, 5)
            let incomeNumber = sqlite3_column_double(statement, 6)
            let incomeMultiple = sqlite3_column_int(statement, 7)
            model.income = MoneyUnit(number: incomeNumber, multiple: Int(incomeMultiple))
            let originalIncomeNumber = sqlite3_column_double(statement, 8)
            let originalIncomeMultiple = sqlite3_column_int(statement, 9)
            model.originalIncome = MoneyUnit(number: originalIncomeNumber, multiple: Int(originalIncomeMultiple))
            model.multiple = sqlite3_column_double(statement, 10)
            model.time = sqlite3_column_double(statement, 11)
            model.isUnlock = sqlite3_column_int(statement, 12) == 1 ? true : false
            model.isOperation = sqlite3_column_int(statement, 13) == 1 ? true : false
            model.hasManager = sqlite3_column_int(statement, 14) == 1 ? true : false
            let upgradeMoneyNumber = sqlite3_column_double(statement, 15)
            let upgradeMoneyMultiple = sqlite3_column_int(statement, 16)
            model.upgradeMoney = MoneyUnit(number: upgradeMoneyNumber, multiple: Int(upgradeMoneyMultiple))
            let unlockMoneyNumber = sqlite3_column_double(statement, 17)
            let unlockMoneyMultiple = sqlite3_column_int(statement, 18)
            model.unlockMoney = MoneyUnit(number: unlockMoneyNumber, multiple: Int(unlockMoneyMultiple))
            list.append(model)
        }
        return list
    }
}
