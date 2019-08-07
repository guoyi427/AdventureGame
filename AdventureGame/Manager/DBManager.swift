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
            
            sqlite3_bind_text(db, 1, model.name, -1, nil)
            sqlite3_bind_text(db, 2, "", -1, nil)
            sqlite3_bind_int(db, 3, Int32(model.level))
            sqlite3_bind_double(db, 4, model.interval)
            sqlite3_bind_double(db, 5, model.originalInterval)
            sqlite3_bind_double(db, 6, model.income.number)
            sqlite3_bind_int(db, 7, Int32(model.income.multiple))
            sqlite3_bind_double(db, 8, model.originalIncome.number)
            sqlite3_bind_int(db, 9, Int32(model.originalIncome.multiple))
            sqlite3_bind_double(db, 10, model.multiple)
            sqlite3_bind_double(db, 11, model.time)
            sqlite3_bind_int(db, 12, model.isUnlock ? 1 : 0)
            sqlite3_bind_int(db, 13, model.isOperation ? 1 : 0)
            sqlite3_bind_int(db, 14, model.hasManager ? 1 : 0)
            sqlite3_bind_double(db, 15, model.upgradeMoney.number)
            sqlite3_bind_int(db, 16, Int32(model.upgradeMoney.multiple))
            sqlite3_bind_double(db, 17, model.unlockMoney.number)
            sqlite3_bind_int(db, 18, Int32(model.unlockMoney.multiple))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("insert store done")
            } else {
                print("insert store failed")
            }
            
            sqlite3_finalize(statement)
        }
    }
}
