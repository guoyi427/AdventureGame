//
//  ProgressView.swift
//  AdventureGame
//
//  Created by Gray on 8/15/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress: Float {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        progress = 0
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        print("\(#function)")
        prepareMaskLayer()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if progress < 0 || progress > 1 {
            return
        }
        
        let progressPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width * CGFloat(progress), height: bounds.height))
        #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).setFill()
        progressPath.fill()
    }
    
    fileprivate func prepareMaskLayer() {
        let shapeLayer = CAShapeLayer.init()
        let path = CGMutablePath.init()
        
        let rightTriangle: CGFloat = 20
        let leftTriangle: CGFloat = 20
        
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.width - rightTriangle, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.width - rightTriangle, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: leftTriangle, y: bounds.midY))
        path.closeSubpath()
        
        shapeLayer.path = path
        self.layer.mask = shapeLayer
    }
}
