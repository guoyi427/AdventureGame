//
//  GameViewController.swift
//  AdventureGame
//
//  Created by Gray on 7/25/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import UIKit
import SnapKit

class GameViewController: UIViewController {

    /// 商店数组
    fileprivate var storeViewList: [StoreView] = []
    fileprivate var timer: Timer?
    
    /// 头部视图
    fileprivate let headView: UIView
    /// 滚动视图
    fileprivate let backgroundView: UIScrollView
    /// 总收入标签
    fileprivate let totalIncomeLabel: UILabel
    /// 每秒收入标签
    fileprivate let ipsLabel: UILabel
    /// 钻石标签
    fileprivate let diamondsLabel: UILabel
    /// 催化剂按钮，可加速赚金币
    fileprivate let catalyzerButton: UIButton
    /// 催化剂剩余时间
    fileprivate let catalyzerTimeLabel: UILabel
    
    required init?(coder aDecoder: NSCoder) {
        headView = UIView(frame: CGRect.zero)
        backgroundView = UIScrollView(frame: CGRect.zero)
        totalIncomeLabel = UILabel(frame: CGRect.zero)
        ipsLabel = UILabel(frame: CGRect.zero)
        diamondsLabel = UILabel(frame: CGRect.zero)
        catalyzerButton = UIButton(frame: CGRect.zero)
        catalyzerTimeLabel = UILabel(frame: CGRect.zero)
        super.init(coder: aDecoder)
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.gameController = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareHeadView()
        prepareContentView()
        
        StoreManager.shared.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdateAction), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        uploadHeadView()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// 刷新商店视图
    func uploadStoreView() {
        //  商店
        for x in 0...MaxStoreIndex {
            let storeView = storeViewList[x]
            StoreManager.shared.setupModel(index: x, view: storeView)
        }
    }
    
    /// 更新头部视图
    func uploadHeadView() {
        diamondsLabel.text = "钻石：\(StoreManager.shared.diamonds)"
        ipsLabel.text = "每秒收入：\(StoreManager.shared.calculateAverageIncomePerSeconds().text())"
        totalIncomeLabel.text = "当前余额\(StoreManager.shared.totalIncome.text())"
    }
}

// MARK: - Private Methods
extension GameViewController {
    /// 更新UI
    fileprivate func prepareHeadView() {
        //  头部
        view.addSubview(headView)
        headView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        //  总收入
        headView.addSubview(totalIncomeLabel)
        totalIncomeLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        totalIncomeLabel.font = UIFont.systemFont(ofSize: 14)
        totalIncomeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        }
        
        //  每秒收入
        headView.addSubview(ipsLabel)
        ipsLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        ipsLabel.font = UIFont.systemFont(ofSize: 14)
        ipsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(totalIncomeLabel.snp.left).offset(-20)
            make.centerY.equalTo(totalIncomeLabel)
        }
        
        //  钻石
        headView.addSubview(diamondsLabel)
        diamondsLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        diamondsLabel.font = UIFont.systemFont(ofSize: 14)
        diamondsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(ipsLabel.snp.left).offset(-20)
            make.centerY.equalTo(ipsLabel)
        }
        
        /// 赚钻石的按钮
        let earnDiamondsButton = UIButton(type: .custom)
        earnDiamondsButton.addTarget(self, action: #selector(earnDiamondsButtonAction), for: .touchUpInside)
        earnDiamondsButton.setTitle("+钻石", for: .normal)
        earnDiamondsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        earnDiamondsButton.setTitleColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), for: .normal)
        headView.addSubview(earnDiamondsButton)
        earnDiamondsButton.snp.makeConstraints { (make) in
            make.right.equalTo(diamondsLabel.snp.left).offset(-5)
            make.centerY.equalTo(diamondsLabel)
        }
        
        /// 催化剂
        headView.addSubview(catalyzerButton)
        catalyzerButton.setTitle("催化剂", for: .normal)
        catalyzerButton.setTitleColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), for: .normal)
        catalyzerButton.addTarget(self, action: #selector(catalyzerButtonAction), for: .touchUpInside)
        catalyzerButton.snp.makeConstraints { (make) in
            make.right.equalTo(earnDiamondsButton.snp.left).offset(-20)
            make.centerY.equalToSuperview()
        }
        
        headView.addSubview(catalyzerTimeLabel)
        catalyzerTimeLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        catalyzerTimeLabel.font = UIFont.systemFont(ofSize: 12)
        catalyzerTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(catalyzerButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    /// 更新UI
    fileprivate func prepareContentView() {
        
        //  背景
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(headView.snp.bottom)
        }
        backgroundView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 470)
        backgroundView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        //  商店
        for x in 0...MaxStoreIndex {
            let storeView = StoreView(frame: CGRect(x: x%2==0 ? 50 : 400, y: x/2*90 + 10, width: 300, height: 80))
            storeViewList.append(storeView)
            backgroundView.addSubview(storeView)
            StoreManager.shared.setupModel(index: x, view: storeView)
        }
    }
    
    /// 计时器更新方法
    @objc fileprivate func timerUpdateAction() {
        let catalyzerInterval = StoreManager.shared.catalyzerEndTime - Date.init().timeIntervalSince1970
        if catalyzerInterval > 0 {
            StoreManager.shared.multiple = 2
            catalyzerTimeLabel.text = "催化剂剩余时间:\(Constant.formatteSeconds(seconds: catalyzerInterval))"
        } else {
            StoreManager.shared.multiple = 1
            catalyzerTimeLabel.text = ""
        }
    }
}

// MARK: - Button Action
extension GameViewController {
    /// 看广告赚钻石按钮
    @objc fileprivate func earnDiamondsButtonAction() {
        let doneAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
            //  菊花
            let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activityView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            activityView.startAnimating()
            self.view.addSubview(activityView)
            
            AdsManager.instance.showInterstitial(viewController: self, complete: { [weak self] (result) in
                activityView.removeFromSuperview()
                if result {
                    //  成功，增加钻石数量
                    StoreManager.shared.diamonds += 10
                    TotalDBManager.shared.saveTotal()
                    self?.uploadHeadView()
                } else {
                    //  跳转广告失败
                    let knowAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
                    let notClickAlert = UIAlertController(title: "您没有点击广告", message: "请点击广告跳转再返回即可", preferredStyle: .alert)
                    notClickAlert.addAction(knowAction)
                    self?.present(notClickAlert, animated: true, completion: nil)
                }
            })
        })
        let cancelAction = UIAlertAction(title: "不需要", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "赚钻石", message: "麻烦您点击广告跳转，可获得10枚钻石，感谢", preferredStyle: .alert)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// 催化剂按钮
    @objc fileprivate func catalyzerButtonAction() {
        //  判断当前是否正在使用催化剂
        if Date.init().timeIntervalSince1970 < StoreManager.shared.catalyzerEndTime {
            let errorAlert = UIAlertController(title: "当前催化剂还在生效", message: "请不要重复使用催化剂", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
            errorAlert.addAction(cancelAction)
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        //  准备弹窗
        let intervalList: [Double] = [1, 2, 4, 8]
        let diamondsList = [5, 10, 15, 25]
        
        let alertController = UIAlertController(title: "催化剂", message: "消耗钻石换取短时间内的生产力加倍，所有店铺收入翻倍", preferredStyle: .alert)
        for x in 0...intervalList.count - 1 {
            let interval = intervalList[x]
            let diamonds = diamondsList[x]
            let alertAction = UIAlertAction(title: "催化剂实效\(interval)小时，消耗\(diamonds)钻石", style: .default) { (action) in
                //  判断钻石是否够用
                if StoreManager.shared.diamonds < diamonds {
                    //  钻石不够
                    let errorAlert = UIAlertController(title: "钻石不够", message: "催化剂实效\(interval)小时，消耗\(diamonds)钻石", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                    errorAlert.addAction(cancelAction)
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                StoreManager.shared.catalyzerEndTime = intervalList[x] * 3600 + Date.init().timeIntervalSince1970
                StoreManager.shared.multiple += 1
                StoreManager.shared.diamonds -= diamonds
                TotalDBManager.shared.saveTotal()
            }
            alertController.addAction(alertAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - StoreManager Delegate
extension GameViewController: StoreManagerDelegate {
    /// 更新总收入
    ///
    /// - Parameter income: 总收入
    func didUpdateTotalIncome(income: MoneyUnit) {
        uploadHeadView()
    }
}
