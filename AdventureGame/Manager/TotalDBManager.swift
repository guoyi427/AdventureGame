//
//  TotalDBManager.swift
//  AdventureGame
//
//  Created by Gray on 8/9/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit
import SQLite3

class TotalDBManager: NSObject {
    static let shared = TotalDBManager()
    var db: OpaquePointer?
    
    fileprivate let columnName_catalyzerEndTime = "catalyzer_end_time"
    
    override init() {
        super.init()
        db = StoreDBManager.shared.db
        prepareTable()
    }
    
    /// 把StoreManager的最新数据同步到Total表中
    func saveTotal() {
        guard let db = db else { return }
        let selectSqlStr = "select * from Total"
        var selectStmt: OpaquePointer?
        let selectPrepare = sqlite3_prepare_v2(db, selectSqlStr, -1, &selectStmt, nil)
        if selectPrepare != SQLITE_OK {
            print("select failure")
            sqlite3_finalize(selectStmt)
            return
        }
        
        if sqlite3_step(selectStmt) == SQLITE_ROW {
            //  有数据 更新
            sqlite3_finalize(selectStmt)
            
            let updateSqlStr = "update Total set total_score_number = \(StoreManager.shared.totalIncome.number), total_score_multiple = \(StoreManager.shared.totalIncome.multiple), leave_time = \(Int(Date().timeIntervalSince1970)), multiple = \(StoreManager.shared.multiple), diamonds = \(StoreManager.shared.diamonds), circle = \(StoreManager.shared.circle), \(columnName_catalyzerEndTime) = \(StoreManager.shared.catalyzerEndTime) where id = 1"
            var updateStmt: OpaquePointer?
            let updatePrepare = sqlite3_prepare_v2(db, updateSqlStr, -1, &updateStmt, nil)
            if updatePrepare != SQLITE_OK {
                print("update fialure")
                sqlite3_finalize(updateStmt)
                return
            }
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                print("update done")
            }
            sqlite3_finalize(updateStmt)
            
        } else {
            //  无数据 插入
            sqlite3_finalize(selectStmt)
            
            let insertSqlStr = "insert into Total (total_score_number, total_score_multiple, leave_time, multiple, diamonds, circle, \(columnName_catalyzerEndTime) values (?, ?, ?, ?, ?, ?, ?)"
            var insertStmt: OpaquePointer?
            let insertPrepare = sqlite3_prepare_v2(db, insertSqlStr, -1, &insertStmt, nil)
            if insertPrepare != SQLITE_OK {
                print("insert prepare fialure")
                sqlite3_finalize(insertStmt)
                return
            }
            
            sqlite3_bind_double(insertStmt, 1, StoreManager.shared.totalIncome.number)
            sqlite3_bind_int(insertStmt, 2, Int32(StoreManager.shared.totalIncome.multiple))
            sqlite3_bind_int(insertStmt, 3, Int32(Date().timeIntervalSince1970))
            sqlite3_bind_double(insertStmt, 4, StoreManager.shared.multiple)
            sqlite3_bind_int(insertStmt, 5, Int32(StoreManager.shared.diamonds))
            sqlite3_bind_int(insertStmt, 6, Int32(StoreManager.shared.circle))
            sqlite3_bind_double(insertStmt, 7, StoreManager.shared.catalyzerEndTime)
            
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                print("insert failure")
            }
            sqlite3_finalize(insertStmt)
        }
    }
    
    /// 查找Total表 并更新到StoreManager
    func queryTotalToShareManager() {
        guard let db = db else { return }
        let selectSqlStr = "select * from Total"
        var selectStmt: OpaquePointer?
        let selectPrepare = sqlite3_prepare_v2(db, selectSqlStr, -1, &selectStmt, nil)
        if selectPrepare != SQLITE_OK {
            print("select prepare is failure")
            sqlite3_finalize(selectStmt)
            return
        }
        
        let selectResult = sqlite3_step(selectStmt)
        if selectResult == SQLITE_ROW {
            let incomeNumber = sqlite3_column_double(selectStmt, 1)
            let incomeMultiple = Int(sqlite3_column_int(selectStmt, 2))
            let income = MoneyUnit(number: incomeNumber, multiple: incomeMultiple)
            StoreManager.shared.totalIncome = income
            StoreManager.shared.leaveTime = Int(sqlite3_column_int(selectStmt, 3))
            StoreManager.shared.multiple = sqlite3_column_double(selectStmt, 4)
            StoreManager.shared.diamonds = Int(sqlite3_column_int(selectStmt, 5))
            StoreManager.shared.circle = Int(sqlite3_column_int(selectStmt, 6))
            StoreManager.shared.catalyzerEndTime = sqlite3_column_double(selectStmt, 7)
        }
        sqlite3_finalize(selectStmt)
    }
}

// MARK: - Private Methods
extension TotalDBManager {
    /// 准备表
    fileprivate func prepareTable() {
        guard let db = db else { return }
        //  查找是否有“catalyzer_end_time"列
        let tableInfoSql = "pragma table_info(Total)"
        var tableInfoStmt: OpaquePointer?
        let tableInfoPrepare = sqlite3_prepare_v2(db, tableInfoSql, -1, &tableInfoStmt, nil)
        if tableInfoPrepare != SQLITE_OK {
            print("pragma failure")
            sqlite3_finalize(tableInfoStmt)
            return
        }
        
        var hasCatalyzer = false
        
        while sqlite3_step(tableInfoStmt) == SQLITE_ROW {
            if let name = sqlite3_column_text(tableInfoStmt, 1) {
                let nameStr = String(cString: name)
                if nameStr == columnName_catalyzerEndTime {
                    hasCatalyzer = true
                }
            }
        }
        
        if hasCatalyzer == false {
            //  不能存在 catalyzer_end_time 列
            let alterSql = "alter table Total add column \(columnName_catalyzerEndTime) double"
            var alterStmt: OpaquePointer?
            let alterPrepare = sqlite3_prepare_v2(db, alterSql, -1, &alterStmt, nil)
            if alterPrepare != SQLITE_OK {
                print("alter table add column failure")
                return;
            }
            if sqlite3_step(alterStmt) == SQLITE_DONE {
                print("alter table done")
            }
        }
    }
}
