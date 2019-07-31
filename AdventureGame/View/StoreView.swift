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
        avatarView = UIImageView(frame: CGRect.zero)
        nameLabel = UILabel(frame: CGRect.zero)
        timeLabel = UILabel(frame: CGRect.zero)
        progressView = UIProgressView(progressViewStyle: .default)
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func prepareUI() {
        backgroundColor = #colorLiteral(red: 0.7019608021, green: 0.8431372643, blue: 1, alpha: 1)
        
        avatarView.image = #imageLiteral(resourceName: "avatar")
        addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.width.height.equalTo(50)
        }
        
        nameLabel.text = "name"
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.top.equalTo(avatarView)
        }
        
        timeLabel.text = "123"
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.right.equalTo(-10)
        }
        
        progressView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView)
            make.right.equalTo(timeLabel.snp.right)
            make.bottom.equalTo(-10)
            make.height.equalTo(5)
        }
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
