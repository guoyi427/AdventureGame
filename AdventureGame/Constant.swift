//
//  Constant.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit

let ScreenSize = UIScreen.main.bounds.size
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

let BackgroundColor = #colorLiteral(red: 0.9843137255, green: 0.968627451, blue: 0.937254902, alpha: 1)
let BlackColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)

let HeadButtonColor = #colorLiteral(red: 0.9254901961, green: 0.6, blue: 0.3764705882, alpha: 1)
let HeadMenuColor = #colorLiteral(red: 0.9333333333, green: 0.7607843137, blue: 0.1725490196, alpha: 1)

let ScoreLabelColor = #colorLiteral(red: 0.7176470588, green: 0.6705882353, blue: 0.6274509804, alpha: 1)
let MatrixHolderBoxColor = #colorLiteral(red: 0.7921568627, green: 0.7450980392, blue: 0.7019607843, alpha: 1)

let MatrixBackgroundColor = #colorLiteral(red: 0.7254901961, green: 0.6745098039, blue: 0.6274509804, alpha: 1)

let GrayTextColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
let BlackTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)


let TitleFontName = "AvenirNext-Bold"

let kUserDefault_UndoCount = "kUserDefault_UndoCount"

let CornerRadius: CGFloat = 5

class Constant: NSObject {
    static let topArea: CGFloat = ScreenHeight == 812 ? 44 : 0
 
    static let cellPadding: CGFloat = 5
    
    /// 格式化秒
    ///
    /// - Parameter seconds: 秒
    /// - Returns: 时间字符串
    static func formatteSeconds(seconds: Double) -> String {
        var result = ""
        if seconds < 60 {
            //  一分钟以内
            result = "\(Int(seconds))秒"
        } else if seconds < 3600 {
            //  一小时以内
            let minutes = Int(seconds / 60)
            result = "\(minutes)分钟"
        } else if seconds < 86400 {
            //  一天以内
            let hours = Int(seconds / 3600)
            let minutes = Int(seconds) % 3600 / 60
            let remaindSeconds = Int(seconds) % 60
            result = String(format: "%d:%02d:%02d", hours, minutes, remaindSeconds)
        }
        return result
    }
}
