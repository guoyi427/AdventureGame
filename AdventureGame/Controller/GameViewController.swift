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

    fileprivate let backgroundView: UIScrollView
    /// 总收入标签
    fileprivate let totalIncomeLabel: UILabel
    /// 每秒收入标签
    fileprivate let ipsLabel: UILabel
    /// 商店数组
    fileprivate var storeViewList: [StoreView] = []
    /// 钻石标签
    fileprivate let diamondsLabel: UILabel
    
    required init?(coder aDecoder: NSCoder) {
        backgroundView = UIScrollView(frame: CGRect.zero)
        totalIncomeLabel = UILabel(frame: CGRect.zero)
        ipsLabel = UILabel(frame: CGRect.zero)
        diamondsLabel = UILabel(frame: CGRect.zero)
        super.init(coder: aDecoder)
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.gameController = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        StoreManager.shared.delegate = self
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func uploadStoreView() {
        //  商店
        for x in 0...MaxStoreIndex {
            let storeView = storeViewList[x]
            StoreManager.shared.setupModel(index: x, view: storeView)
        }
    }
}

// MARK: - Private Methods
extension GameViewController {
    /// 更新UI
    fileprivate func prepareUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        //  背景
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(50)
        }
        backgroundView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 470)
        backgroundView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        //  总收入
        view.addSubview(totalIncomeLabel)
        totalIncomeLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        totalIncomeLabel.text = StoreManager.shared.totalIncome.text()
        totalIncomeLabel.font = UIFont.systemFont(ofSize: 20)
        totalIncomeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-50)
            make.top.equalTo(5)
        }
        
        //  每秒收入
        view.addSubview(ipsLabel)
        ipsLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        ipsLabel.text = "\(StoreManager.shared.calculateAverageIncomePerSeconds().text())每秒"
        ipsLabel.font = UIFont.systemFont(ofSize: 18)
        ipsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(totalIncomeLabel.snp.left).offset(-20)
            make.centerY.equalTo(totalIncomeLabel)
        }
        
        //  钻石
        view.addSubview(diamondsLabel)
        diamondsLabel.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        diamondsLabel.text = "\(StoreManager.shared.diamonds)枚钻石"
        diamondsLabel.font = UIFont.systemFont(ofSize: 18)
        diamondsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(ipsLabel.snp.left).offset(-20)
            make.centerY.equalTo(ipsLabel)
        }
        
        /// 赚钻石的按钮
        let earnDiamondsButton = UIButton(type: .custom)
        earnDiamondsButton.addTarget(self, action: #selector(earnDiamondsButtonAction), for: .touchUpInside)
        earnDiamondsButton.setTitle("+钻石", for: .normal)
        earnDiamondsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        earnDiamondsButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .normal)
        view.addSubview(earnDiamondsButton)
        earnDiamondsButton.snp.makeConstraints { (make) in
            make.right.equalTo(diamondsLabel.snp.left).offset(-5)
            make.centerY.equalTo(diamondsLabel)
        }
        
        //  商店
        for x in 0...MaxStoreIndex {
            let storeView = StoreView(frame: CGRect(x: x%2==0 ? 50 : 400, y: x/2*90 + 10, width: 300, height: 80))
            storeViewList.append(storeView)
            backgroundView.addSubview(storeView)
            StoreManager.shared.setupModel(index: x, view: storeView)
        }
    }
}

// MARK: - Button Action
extension GameViewController {
    @objc
    fileprivate func earnDiamondsButtonAction() {
        let doneAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
            //  菊花
            let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activityView.frame = CGRect(x: ScreenWidth/2 - 20, y: ScreenHeight/2 - 20, width: 40, height: 40)
            activityView.startAnimating()
            self.view.addSubview(activityView)
            
            AdsManager.instance.showInterstitial(viewController: self, complete: { [weak self] (result) in
                activityView.removeFromSuperview()
                if result {
                    //  成功，增加钻石数量
                    StoreManager.shared.diamonds += 10
                    TotalDBManager.shared.saveTotal()
                    self?.diamondsLabel.text = "\(StoreManager.shared.diamonds)枚钻石"
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
}

// MARK: - StoreManager Delegate
extension GameViewController: StoreManagerDelegate {
    /// 更新总收入
    ///
    /// - Parameter income: 总收入
    func didUpdateTotalIncome(income: MoneyUnit) {
        totalIncomeLabel.text = income.text()
        ipsLabel.text = "\(StoreManager.shared.calculateAverageIncomePerSeconds().text())每秒"
    }
}
