//
//  MoneyUnit.swift
//  AdventureGame
//
//  Created by Gray on 8/2/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import Foundation

/// 倍数最大差 超过这个差值的两个数字 计算忽略不计
private let MaxMultipleDiffer = 5
/// 倍数因子
private let MultipleFactor: Double = 1000

private let textList = ["", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n"]

struct MoneyUnit {
    var number: Double
    var multiple: Int
    
    static var zero: MoneyUnit {
        return MoneyUnit(number: 0, multiple: 0)
    }

    /// 生成文字
    ///
    /// - Returns: 文字
    func text() -> String {
        return String(format: "%.2f%@", number, textList[multiple])
    }
    
    /// 根据一个int 生成一个MoneyUnit
    ///
    /// - Parameter income: int值
    /// - Returns: MoneyUnit
    static func creatIncome(income: Double) -> MoneyUnit {
        var value = income
        var n = 0
        while value >= MultipleFactor {
            n += 1
            value = value / MultipleFactor
        }
        return MoneyUnit(number: value, multiple: n)
    }
    
    mutating func lowerMultiple() {
        if self.number < 1, self.multiple > 0 {
            self.number = self.number * MultipleFactor
            self.multiple -= 1
        }
        
        if self.number < 1, self.multiple > 0 {
            self.lowerMultiple()
        }
    }
    
    /// 运算符
    /// 小于
    static func < (left: MoneyUnit, right: MoneyUnit) -> Bool {
        if left.multiple == right.multiple {
            //  倍数相同
            return left.number < right.number
        } else {
            let leftSign = left.number > 0 ? 1 : -1
            let rightSign = right.number > 0 ? 1 : -1
            return left.multiple * leftSign < right.multiple * rightSign
        }
    }
    
    static func <= (left: MoneyUnit, right: MoneyUnit) -> Bool {
        if left.multiple == right.multiple {
            return left.number <= right.number
        } else {
            let leftSign = left.number > 0 ? 1 : -1
            let rightSign = right.number > 0 ? 1 : -1
            return left.multiple * leftSign <= right.multiple * rightSign
        }
    }
    
    static func > (left: MoneyUnit, right: MoneyUnit) -> Bool {
        if left.multiple == right.multiple {
            return left.number > right.number
        } else {
            let leftSign = left.number > 0 ? 1 : -1
            let rightSign = right.number > 0 ? 1 : -1
            return left.multiple * leftSign > right.multiple * rightSign
        }
    }
    
    static func >= (left: MoneyUnit, right: MoneyUnit) -> Bool {
        if left.multiple == right.multiple {
            return left.number >= right.number
        } else {
            let leftSign = left.number > 0 ? 1 : -1
            let rightSign = right.number > 0 ? 1 : -1
            return left.multiple * leftSign >= right.multiple * rightSign
        }
    }
    
    static func == (left: MoneyUnit, right: MoneyUnit) -> Bool {
        if left.multiple == right.multiple {
            return left.number == right.number
        } else {
            return false
        }
    }
    
    static prefix func - (money: MoneyUnit) -> MoneyUnit {
        return MoneyUnit(number: -money.number, multiple: money.multiple)
    }
    
    static func + (left: MoneyUnit, right: MoneyUnit) -> MoneyUnit {
        let differ = abs(left.multiple - right.multiple)
        let leftBigger = left > right
        
        //  超过这个差值的两个数字 计算忽略不计 返回更大值
        if differ > MaxMultipleDiffer {
            return leftBigger ? left : right
        }
        
        if leftBigger {
            let leftNumber = left.number * pow(Double(MultipleFactor), Double(differ))
            let newNumber = (leftNumber + right.number) / pow(Double(MultipleFactor), Double(differ))
            return MoneyUnit(number: newNumber, multiple: left.multiple)
        } else {
            let rightNumber = right.number * pow(Double(MultipleFactor), Double(differ))
            let newNumber = (rightNumber + left.number) / pow(Double(MultipleFactor), Double(differ))
            return MoneyUnit(number: newNumber, multiple: right.multiple)
        }
    }
    
    static func += (left: inout MoneyUnit, right: MoneyUnit) {
        left = left + right
        var n = left.multiple
        var value = left.number
        while value >= MultipleFactor {
            value = value / MultipleFactor
            n += 1
        }
        left = MoneyUnit(number: value, multiple: n)
    }
    
    static func * (left: MoneyUnit, right: MoneyUnit) -> MoneyUnit {
        var n = left.multiple + right.multiple
        var value = left.number * right.number
        while value >= MultipleFactor {
            value = value / MultipleFactor
            n += 1
        }
        return MoneyUnit(number: Double(value), multiple: n)
    }
    
    static func * (left: MoneyUnit, right: Double) -> MoneyUnit {
        var value = left.number * right
        var n = left.multiple
        while value > MultipleFactor {
            value = value / MultipleFactor
            n += 1
        }
        return MoneyUnit(number: value, multiple: n)
    }
    
    static func / (left: MoneyUnit, right: Double) -> MoneyUnit {
        var value = left.number / right
        var n = left.multiple
        while value < 1 {
            value = value * MultipleFactor
            n -= 1
        }
        
        let result = MoneyUnit(number: value, multiple: n)
        
        return result
    }
}
