//
//  DBManager.swift
//  AdventureGame
//
//  Created by Gray on 8/7/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import Foundation
import SQLite3

class StoreDBManager: NSObject {
    static let shared = StoreDBManager()
    
    var db: OpaquePointer?
    
    override init() {
        super.init()
        guard let path = Bundle.main.path(forResource: "AdventureGame", ofType: "db") else { return }
        //  复制到沙盒
        guard let pathPrefix = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        let cachePath = pathPrefix + "/AdventureGame.db"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: cachePath) {
            do {
                try fileManager.copyItem(atPath: path, toPath: cachePath)
            } catch {
                print("copy failure")
            }
        }
        
        let state = sqlite3_open_v2(cachePath, &db, SQLITE_OPEN_READWRITE, nil)
        if state != SQLITE_OK {
            print("open db failed")
        }
        print("db path = \(cachePath)")
    }
    
    func saveAllStoreAndTotal() {
        guard let db = db else { return }
        let insertSqlStr = "insert into Store (sid, level, interval, original_interval, income_number, income_multiple, original_income_number, original_income_multiple, multiple, time, isUnlock, isOperation, hasManager, upgradeMoney_number, upgradeMoney_multiple, unlockMoney_number, unlockMoney_multiple) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

        for model in StoreManager.shared.list {
            //  判断本地是否已经存在这个模型
            let selectSqlStr = "select id from Store where sid = \(model.sid)"
            var selectStatement: OpaquePointer?
            let selectResult = sqlite3_prepare_v2(db, selectSqlStr, -1, &selectStatement, nil)
            if selectResult != SQLITE_OK {
                sqlite3_finalize(selectStatement)
                print("select \(model.name) failure")
                return
            }
            
            if sqlite3_step(selectStatement) == SQLITE_ROW {
                //  找到了 更新后退出
                let idNumber = sqlite3_column_int(selectStatement, 0)
                print("\(model.name) id = \(idNumber) is find")
                //  更新
                let updateSqlStr = "update Store set level = \(model.level), interval = \(model.interval), income_number = \(model.income.number), income_multiple = \(model.income.multiple), multiple = \(model.multiple), time = \(model.time), isUnlock = \(model.isUnlock), isOperation = \(model.isOperation), hasManager = \(model.hasManager), upgradeMoney_number = \(model.upgradeMoney.number), upgradeMoney_multiple = \(model.upgradeMoney.multiple) where sid = \(model.sid)"
                var updateStatement: OpaquePointer?
                let updateResult = sqlite3_prepare_v2(db, updateSqlStr, -1, &updateStatement, nil)
                if updateResult == SQLITE_OK, sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("update \(model.name) done")
                }
                sqlite3_finalize(updateStatement)
                sqlite3_finalize(selectStatement)
                continue
            }
            sqlite3_finalize(selectStatement)
            
            //  插入
            var insertStatement: OpaquePointer?
            let insertResult = sqlite3_prepare_v2(db, insertSqlStr, -1, &insertStatement, nil)
            if insertResult != SQLITE_OK {
                sqlite3_finalize(insertStatement)
                print("insert store error")
                return
            }
            
            sqlite3_bind_int(insertStatement, 1, Int32(model.sid))
            sqlite3_bind_int(insertStatement, 2, Int32(model.level))
            sqlite3_bind_double(insertStatement, 3, model.interval)
            sqlite3_bind_double(insertStatement, 4, model.originalInterval)
            sqlite3_bind_double(insertStatement, 5, model.income.number)
            sqlite3_bind_int(insertStatement, 6, Int32(model.income.multiple))
            sqlite3_bind_double(insertStatement, 7, model.originalIncome.number)
            sqlite3_bind_int(insertStatement, 8, Int32(model.originalIncome.multiple))
            sqlite3_bind_double(insertStatement, 9, model.multiple)
            sqlite3_bind_double(insertStatement, 10, model.time)
            sqlite3_bind_int(insertStatement, 11, model.isUnlock ? 1 : 0)
            sqlite3_bind_int(insertStatement, 12, model.isOperation ? 1 : 0)
            sqlite3_bind_int(insertStatement, 13, model.hasManager ? 1 : 0)
            sqlite3_bind_double(insertStatement, 14, model.upgradeMoney.number)
            sqlite3_bind_int(insertStatement, 15, Int32(model.upgradeMoney.multiple))
            sqlite3_bind_double(insertStatement, 16, model.unlockMoney.number)
            sqlite3_bind_int(insertStatement, 17, Int32(model.unlockMoney.multiple))
            
            let insertStep = sqlite3_step(insertStatement)
            if insertStep == SQLITE_DONE {
                print("insert \(model.name) done")
            } else {
                print("insert \(model.name) failed \(String(describing: sqlite3_errmsg(db))) result = \(insertStep)")
            }
            
            sqlite3_finalize(insertStatement)
        }
        
        TotalDBManager.shared.saveTotal()
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
            model.sid = Int(sqlite3_column_int(statement, 1))
            if model.sid < NameList.count {
                model.name = NameList[model.sid]
            }
            if model.sid < AvatarList.count {
                model.avatarImage = AvatarList[model.sid]
            }
            model.level = Int(sqlite3_column_int(statement, 2))
            model.interval = sqlite3_column_double(statement, 3)
            model.originalInterval = sqlite3_column_double(statement, 4)
            let incomeNumber = sqlite3_column_double(statement, 5)
            let incomeMultiple = sqlite3_column_int(statement, 6)
            model.income = MoneyUnit(number: incomeNumber, multiple: Int(incomeMultiple))
            let originalIncomeNumber = sqlite3_column_double(statement, 7)
            let originalIncomeMultiple = sqlite3_column_int(statement, 8)
            model.originalIncome = MoneyUnit(number: originalIncomeNumber, multiple: Int(originalIncomeMultiple))
            model.multiple = sqlite3_column_double(statement, 9)
            model.time = sqlite3_column_double(statement, 10)
            model.isUnlock = sqlite3_column_int(statement, 11) == 1 ? true : false
            model.isOperation = sqlite3_column_int(statement, 12) == 1 ? true : model.isUnlock
            model.hasManager = sqlite3_column_int(statement, 13) == 1 ? true : false
            let upgradeMoneyNumber = sqlite3_column_double(statement, 14)
            let upgradeMoneyMultiple = sqlite3_column_int(statement, 15)
            model.upgradeMoney = MoneyUnit(number: upgradeMoneyNumber, multiple: Int(upgradeMoneyMultiple))
            let unlockMoneyNumber = sqlite3_column_double(statement, 16)
            let unlockMoneyMultiple = sqlite3_column_int(statement, 17)
            model.unlockMoney = MoneyUnit(number: unlockMoneyNumber, multiple: Int(unlockMoneyMultiple))
            list.append(model)
        }
        sqlite3_finalize(statement)
        return list
    }
    
    func save(model: StoreModel) {
        guard let db = db else { return }
        let updateSqlStr = "update Store set level = \(model.level), interval = \(model.interval), income_number = \(model.income.number), income_multiple = \(model.income.multiple), multiple = \(model.multiple), time = \(model.time), isUnlock = \(model.isUnlock), isOperation = \(model.isOperation), hasManager = \(model.hasManager), upgradeMoney_number = \(model.upgradeMoney.number), upgradeMoney_multiple = \(model.upgradeMoney.multiple) where sid = \(model.sid)"
        var stmt: OpaquePointer?
        let prepare = sqlite3_prepare_v2(db, updateSqlStr, -1, &stmt, nil)
        if prepare != SQLITE_OK {
            print("update \(model) prepare failure")
            return
        }
        let result = sqlite3_step(stmt)
        if result == SQLITE_DONE {
            print("update \(model) success")
        }
        sqlite3_finalize(stmt)
    }
}
