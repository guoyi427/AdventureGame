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
//    fileprivate let operationButton: UIButton
    fileprivate let unlockButton: UIButton
    
    fileprivate let contentView: UIView
    fileprivate let avatarView: UIImageView
    fileprivate let incomeLabel: UILabel
    fileprivate let levelLabel: UILabel
//    fileprivate let levelTitleLabel: UILabel
    fileprivate let timeLabel: UILabel
    fileprivate let progressView: UIProgressView

    var storeModel: StoreModel?
    
    
    override init(frame: CGRect) {
        upgradeButton = UIButton(type: .custom)
//        operationButton = UIButton(type: .custom)
        unlockButton = UIButton(type: .custom)
        
        contentView = UIView(frame: CGRect.zero)
        avatarView = UIImageView(frame: CGRect.zero)
        incomeLabel = UILabel(frame: CGRect.zero)
        levelLabel = UILabel(frame: CGRect.zero)
//        levelTitleLabel = UILabel(frame: CGRect.zero)
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
        
        //  更新基础数据
        avatarView.image = model.avatarImage
        incomeLabel.text = model.income.text()
        levelLabel.text = "\(model.level)"
        
        //  剩余时间
        let time = model.interval - model.time
        timeLabel.text = String(format: "%.1fs", time >= 0 ? time : 0)
        
        //  更新执行进度
        let progress = Float(model.time) / Float(model.interval)
        progressView.progress = progress < 1 ? progress : 0
        
        //  如果金币足够升级，点亮升级按钮
        upgradeButton.layer.borderWidth = StoreManager.shared.totalIncome >= model.upgradeMoney ? 2 : 0
        
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
        backgroundColor = #colorLiteral(red: 0.7019608021, green: 0.8431372643, blue: 1, alpha: 1)
        
        //  背景，除了解锁按钮，所有视图都在这上面
        contentView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        addSubview(contentView)
        
        prepareButton()
        prepareContentView()
        prepareLayout()
    }
    
    fileprivate func prepareButton() {
        upgradeButton.addTarget(self, action: #selector(upgradeButtonAction), for: .touchUpInside)
        upgradeButton.setTitle("升级", for: .normal)
        upgradeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        upgradeButton.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        upgradeButton.layer.borderWidth = 0
        contentView.addSubview(upgradeButton)
        
//        operationButton.addTarget(self, action: #selector(operationButtonAction), for: .touchUpInside)
//        operationButton.setTitle("执行", for: .normal)
//        operationButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(operationButton)
        
        unlockButton.addTarget(self, action: #selector(unlockButtonAction), for: .touchUpInside)
        unlockButton.setTitle("解锁店铺", for: .normal)
        unlockButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        unlockButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        unlockButton.layer.borderWidth = 0
        addSubview(unlockButton)
    }
    
    fileprivate func prepareContentView() {
        contentView.addSubview(avatarView)

        incomeLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(incomeLabel)
        
        contentView.addSubview(levelLabel)
        
//        levelTitleLabel.text = "level:"
//        levelTitleLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        levelTitleLabel.font = UIFont.systemFont(ofSize: 10)
//        contentView.addSubview(levelTitleLabel)
        
        contentView.addSubview(timeLabel)
        
        progressView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        contentView.addSubview(progressView)
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
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(50)
        }
        
        //  收入标签
        incomeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(progressView)
        }
        
        //  升级
        upgradeButton.snp.makeConstraints { (make) in
            make.left.equalTo(progressView)
            make.top.equalTo(progressView.snp.bottom)
            make.bottom.equalTo(0)
            make.right.equalTo(timeLabel.snp.left)
        }
        
//        operationButton.snp.makeConstraints { (make) in
//            make.left.bottom.equalTo(0)
//            make.width.equalTo(upgradeButton)
//            make.top.equalTo(upgradeButton.snp.bottom)
//        }
        
        //  等级
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(0)
            make.centerX.equalTo(avatarView)
        }
        
//        levelTitleLabel.snp.makeConstraints { (make) in
//            make.right.equalTo(levelLabel.snp.left).offset(-5)
//            make.centerY.equalTo(levelLabel)
//        }
        
        //  倒计时
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(upgradeButton)
            make.left.equalTo(upgradeButton.snp.right)
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
    
    /// 执行按钮方法
//    @objc fileprivate func operationButtonAction() {
//        guard let model = storeModel else { return }
//        model.operation()
//    }
    
    /// 解锁商店方法
    @objc fileprivate func unlockButtonAction() {
        guard let model = storeModel else { return }
        if !model.isUnlock {
            model.unlockStore()
            self.update(model: model)
        }
    }
}
