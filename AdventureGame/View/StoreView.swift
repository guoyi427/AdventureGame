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
    fileprivate let upgradeLabel: UILabel
    fileprivate let upgradeMoneyLabel: UILabel
    
    fileprivate let unlockButton: UIButton
    
    fileprivate let contentView: UIView
    fileprivate let avatarView: UIImageView
    fileprivate let incomeLabel: UILabel
    fileprivate let levelLabel: UILabel
    fileprivate let timeLabel: UILabel
    fileprivate let progressView: ProgressView

    var storeModel: StoreModel?
    
    
    override init(frame: CGRect) {
        upgradeButton = UIButton(type: .custom)
        upgradeLabel = UILabel(frame: CGRect.zero)
        upgradeMoneyLabel = UILabel(frame: CGRect.zero)
        
        unlockButton = UIButton(type: .custom)
        
        contentView = UIView(frame: CGRect.zero)
        avatarView = UIImageView(frame: CGRect.zero)
        progressView = ProgressView(frame: CGRect.zero)
        incomeLabel = UILabel(frame: CGRect.zero)
        levelLabel = UILabel(frame: CGRect.zero)
        timeLabel = UILabel(frame: CGRect.zero)
        
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: StoreModel) {
        storeModel = model
        
        //  更新基础数据
        avatarView.image = model.avatarImage
        incomeLabel.text = (model.income * StoreManager.shared.multiple).text()
        levelLabel.text = "\(model.level)"
        
        //  剩余时间
        let time = model.interval - model.time
        timeLabel.text = String(format: "%.1fs", time >= 0 ? time : 0)
        
        //  更新执行进度
        //  如果间隔小于刷新频率，就将进度条设置成满进度
        var progress = Float(model.time) / Float(model.interval)
        if model.interval < TimerInterval * 2 {
            progress = 1
        }
        progressView.progress = progress <= 1 ? progress : 0
        
        //  如果金币足够升级，点亮升级按钮
        upgradeButton.layer.borderWidth = StoreManager.shared.totalIncome >= model.upgradeMoney ? 2 : 0
        
        //  升级需要的金币
        upgradeMoneyLabel.text = model.upgradeMoney.text()
        
        contentView.isHidden = !model.isUnlock
        unlockButton.isHidden = model.isUnlock
        
        if model.isUnlock || model.isOperation {
            model.operation()
        }
    }
}


fileprivate let Width_Button = 50
fileprivate let Width_Avatar = 50

// MARK: - Private Methods
extension StoreView {
    
    fileprivate func prepareUI() {
        //  背景，除了解锁按钮，所有视图都在这上面
        addSubview(contentView)
        
        prepareButton()
        prepareContentView()
        prepareLayout()
    }
    
    fileprivate func prepareButton() {
        upgradeButton.addTarget(self, action: #selector(upgradeButtonAction), for: .touchUpInside)
        upgradeButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.672638317, blue: 0.9686274529, alpha: 1)
        upgradeButton.layer.borderColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        upgradeButton.layer.borderWidth = 0
        contentView.addSubview(upgradeButton)
        
        upgradeLabel.text = "升级"
        upgradeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        upgradeLabel.font = UIFont.systemFont(ofSize: 12)
        upgradeButton.addSubview(upgradeLabel)
        
        upgradeMoneyLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        upgradeMoneyLabel.font = UIFont.systemFont(ofSize: 14)
        upgradeButton.addSubview(upgradeMoneyLabel)
        
        unlockButton.addTarget(self, action: #selector(unlockButtonAction), for: .touchUpInside)
        unlockButton.setTitle("解锁店铺", for: .normal)
        unlockButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        unlockButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        unlockButton.layer.borderWidth = 0
        addSubview(unlockButton)
    }
    
    fileprivate func prepareContentView() {
        avatarView.layer.cornerRadius = CGFloat(Width_Avatar / 2)
        avatarView.layer.masksToBounds = true
        contentView.addSubview(avatarView)
        
        let avatarTapGR = UITapGestureRecognizer(target: self, action: #selector(tapAvatarGestureRecognizerAction))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(avatarTapGR)
        
        contentView.addSubview(progressView)
        
        incomeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        incomeLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(incomeLabel)
        
        levelLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.addSubview(levelLabel)
        
        timeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.addSubview(timeLabel)
    }
    
    /// 准备约束
    fileprivate func prepareLayout() {
        //  背景
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        //  头像
        avatarView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(Width_Avatar)
        }
        
        //  进度条
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(40)
        }
        
        //  收入标签
        incomeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(progressView)
        }
        
        //  升级
        upgradeButton.snp.makeConstraints { (make) in
            make.left.equalTo(progressView)
            make.width.greaterThanOrEqualTo(200)
            make.top.equalTo(progressView.snp.bottom).offset(5)
            make.bottom.equalTo(0)
        }
        
        //  升级标签
        upgradeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalToSuperview()
        }
        
        //  升级需要的金币数量
        upgradeMoneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalToSuperview()
        }
        
        //  等级
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(0)
            make.centerX.equalTo(avatarView)
        }
        
        //  倒计时
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(upgradeButton)
            make.left.equalTo(upgradeButton.snp.right).offset(10)
            make.width.equalTo(100)
        }
        
        //  解锁
        unlockButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
    }
}

// MARK: - Button Action
extension StoreView {
    /// 升级按钮方法
    @objc fileprivate func upgradeButtonAction() {
        guard let model = storeModel else { return }
        model.upgrade()
    }
    
    /// 解锁商店方法
    @objc fileprivate func unlockButtonAction() {
        guard let model = storeModel else { return }
        if !model.isUnlock {
            model.unlockStore()
            self.update(model: model)
        }
    }
    
    /// 点击头像方法
    @objc fileprivate func tapAvatarGestureRecognizerAction() {
        guard let model = storeModel else { return }
        StoreManager.shared.changeTotaleIncome(income: model.income * StoreManager.shared.multiple)
    }
}
