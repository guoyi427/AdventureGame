//
//  StoreView.swift
//  AdventureGame
//
//  Created by Gray on 7/31/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit

class StoreView: UIView {
    
    fileprivate let upgradeButton: UIButton
    fileprivate let operationButton: UIButton
    
    fileprivate let contentView: UIView
    fileprivate let avatarView: UIImageView
    fileprivate let nameLabel: UILabel
    fileprivate let incomeLabel: UILabel
    fileprivate let levelLabel: UILabel
    fileprivate let timeLabel: UILabel
    fileprivate let progressView: UIProgressView

    var storeModel: StoreModel?
    
    
    override init(frame: CGRect) {
        upgradeButton = UIButton(type: .custom)
        operationButton = UIButton(type: .custom)
        
        contentView = UIView(frame: CGRect.zero)
        avatarView = UIImageView(frame: CGRect.zero)
        nameLabel = UILabel(frame: CGRect.zero)
        incomeLabel = UILabel(frame: CGRect.zero)
        levelLabel = UILabel(frame: CGRect.zero)
        timeLabel = UILabel(frame: CGRect.zero)
        progressView = UIProgressView(progressViewStyle: .default)
        
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: StoreModel) {
        storeModel = model
        
        nameLabel.text = model.name
        avatarView.image = model.avatarImage
        incomeLabel.text = "\(model.income)"
        levelLabel.text = "\(model.level)"
        timeLabel.text = "\(model.interval - Int(model.time))"
        
        let progress = Float(model.time) / Float(model.interval)
        progressView.progress = progress < 1 ? progress : 0
    }
}


fileprivate let Width_Button = 50
fileprivate let Width_Avatar = 50

// MARK: - Private Methods
extension StoreView {
    
    fileprivate func prepareUI() {
        backgroundColor = #colorLiteral(red: 0.7019608021, green: 0.8431372643, blue: 1, alpha: 1)
        
        prepareButton()
        
        prepareContentView()
    }
    
    fileprivate func prepareButton() {
        addSubview(upgradeButton)
        upgradeButton.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.bottom.equalTo(self.snp.centerY)
            make.width.equalTo(Width_Button)
        }
        upgradeButton.addTarget(self, action: #selector(upgradeButtonAction), for: .touchUpInside)
        upgradeButton.setTitle("升级", for: .normal)
        upgradeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        addSubview(operationButton)
        operationButton.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(0)
            make.width.equalTo(upgradeButton)
            make.top.equalTo(upgradeButton.snp.bottom)
        }
        operationButton.addTarget(self, action: #selector(operationButtonAction), for: .touchUpInside)
        operationButton.setTitle("执行", for: .normal)
        operationButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    fileprivate func prepareContentView() {
        addSubview(contentView)
        contentView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(upgradeButton.snp.right)
            make.top.bottom.right.equalTo(0)
        }
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.width.height.equalTo(50)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.top.equalTo(avatarView)
        }
        
        contentView.addSubview(incomeLabel)
        incomeLabel.font = UIFont.systemFont(ofSize: 18)
        incomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.right.equalTo(-10)
        }
        
        let levelTitleLabel = UILabel(frame: CGRect.zero)
        levelTitleLabel.text = "level:"
        levelTitleLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        levelTitleLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(levelTitleLabel)
        levelTitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(levelLabel.snp.left).offset(-5)
            make.centerY.equalTo(levelLabel)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(levelLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(progressView)
        progressView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView)
            make.right.equalTo(timeLabel.snp.right)
            make.bottom.equalTo(-10)
            make.height.equalTo(5)
        }
    }
    
    /// 升级按钮方法
    @objc fileprivate func upgradeButtonAction() {
        guard let model = storeModel else { return }
        model.upgrade()
    }
    
    /// 执行按钮方法
    @objc fileprivate func operationButtonAction() {
        guard let model = storeModel else { return }
        model.operation()
    }
}
