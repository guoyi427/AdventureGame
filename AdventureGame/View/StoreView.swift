//
//  StoreView.swift
//  AdventureGame
//
//  Created by Gray on 7/31/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

class StoreView: UIView {
    
    fileprivate let avatarView: UIImageView
    fileprivate let nameLabel: UILabel
    fileprivate let timeLabel: UILabel
    fileprivate let progressView: UIProgressView
    

    override init(frame: CGRect) {
        avatarView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        nameLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 100, height: 20))
        timeLabel = UILabel(frame: CGRect(x: 0, y: 150, width: 50, height: 20))
        progressView = UIProgressView(progressViewStyle: .default)
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func prepareUI() {
        backgroundColor = #colorLiteral(red: 0.7019608021, green: 0.8431372643, blue: 1, alpha: 1)
    }
    
    func updateName(name: String) {
        nameLabel.text = name
    }
    
    func updateAvatar(avatar: UIImage) {
        avatarView.image = avatar
    }
    
    func updateTime(time: CGFloat) {
        timeLabel.text = "\(time)"
    }
    
    func updateProgress(progress: Float) {
        progressView.progress = progress
    }
}
