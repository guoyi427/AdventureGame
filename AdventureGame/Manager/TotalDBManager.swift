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
    
    override init() {
        super.init()
        db = StoreDBManager.shared.db
    }
    
    func saveTotal() {
        guard let db = db else { return }
        let selectSqlStr = "select total from Total where id = 0"
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
            
            let updateSqlStr = "update Total set total_score_number = \(StoreManager.shared.totalIncome.number), total_score_multiple = \(StoreManager.shared.totalIncome.multiple), leave_time = \(Int(Date().timeIntervalSince1970)), multiple = \(StoreManager.shared.multiple), diamonds = \(StoreManager.shared.diamonds), circle = \(StoreManager.shared.circle) where id = 0"
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
            
            let insertSqlStr = "insert into Total (total_score_number, total_score_multiple, leave_time, multiple, diamonds, circle) values (?, ?, ?, ?, ?, ?)"
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
            sqlite3_bind_int(insertStmt, 4, Int32(StoreManager.shared.multiple))
            sqlite3_bind_int(insertStmt, 5, Int32(StoreManager.shared.diamonds))
            sqlite3_bind_int(insertStmt, 6, Int32(StoreManager.shared.circle))
            
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                print("insert failure")
            }
            sqlite3_finalize(insertStmt)
        }
    }
    
    func queryTotalToShareManager() {
        
    }
}
