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
    fileprivate var storeViewList: [StoreView] = []
    
    required init?(coder aDecoder: NSCoder) {
        backgroundView = UIScrollView(frame: CGRect.zero)
        totalIncomeLabel = UILabel(frame: CGRect.zero)
        ipsLabel = UILabel(frame: CGRect.zero)
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
        
        //  商店
        for x in 0...MaxStoreIndex {
            let storeView = StoreView(frame: CGRect(x: x%2==0 ? 50 : 400, y: x/2*90 + 10, width: 300, height: 80))
            storeViewList.append(storeView)
            backgroundView.addSubview(storeView)
            StoreManager.shared.setupModel(index: x, view: storeView)
        }
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
