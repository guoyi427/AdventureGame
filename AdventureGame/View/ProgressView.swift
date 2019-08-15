//
//  ProgressView.swift
//  AdventureGame
//
//  Created by Gray on 8/15/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress: Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let rightTriangle: CGFloat = 30
        let leftTriangle: CGFloat = 10
        
        //  边框
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width - rightTriangle, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width - rightTriangle, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: leftTriangle, y: rect.midY))
        path.close()
        path.lineWidth = 1
        path.lineCapStyle = .round
        #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).setStroke()
        path.stroke()
        
        //  内部
//        let maxWidth = rect.width * CGFloat(progress)
//        let innerPath = UIBezierPath.init()
//        innerPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
//        innerPath.addLine(to: CGPoint(x: rect.width - rightTriangle, y: rect.minY))
//        innerPath.addLine(to: CGPoint(x: rect.width, y: rect.midY))
//        innerPath.addLine(to: CGPoint(x: rect.width - rightTriangle, y: rect.maxY))
//        innerPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        innerPath.addLine(to: CGPoint(x: leftTriangle, y: rect.midY))
//        innerPath.close()
//        innerPath.lineWidth = 1
//        innerPath.lineCapStyle = .round
//
//        #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).setFill()
//        innerPath.fill()
    }
    

}
