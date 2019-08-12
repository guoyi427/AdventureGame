//
//  AdventureGameTests.swift
//  AdventureGameTests
//
//  Created by Gray on 7/25/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import XCTest
@testable import AdventureGame

class AdventureGameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testDBManager() {
        
        let list2 = StoreDBManager.shared.queryStoreList()
        print(list2)
        
        StoreDBManager.shared.saveAllStoreAndTotal()
        
        let list = StoreDBManager.shared.queryStoreList()
        print(list)
    }
    
    func testTotalDBManager() {
        TotalDBManager.shared.saveTotal()
        TotalDBManager.shared.queryTotalToShareManager()
    }
    
    func testIPS() {
        let ips = StoreManager.shared.calculateAverageIncomePerSeconds()
        print(ips)
    }
}
