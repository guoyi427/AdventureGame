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
    fileprivate let totalIncomeLabel: UILabel
    
    required init?(coder aDecoder: NSCoder) {
        backgroundView = UIScrollView(frame: CGRect.zero)
        totalIncomeLabel = UILabel(frame: CGRect.zero)
        super.init(coder: aDecoder)
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
        backgroundView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        backgroundView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        //  总收入
        view.addSubview(totalIncomeLabel)
        totalIncomeLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        totalIncomeLabel.text = "0"
        totalIncomeLabel.font = UIFont.systemFont(ofSize: 20)
        totalIncomeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-50)
            make.top.equalTo(5)
        }
        
        //  商店
        for x in 0...MaxStoreIndex {
            let storeView = StoreView(frame: CGRect(x: x%2==0 ? 50 : 400, y: x/2*90, width: 300, height: 80))
            backgroundView.addSubview(storeView)
            storeView.update(model: StoreManager.shared.getModel(index: x))
        }
    }
}

// MARK: - StoreManager Delegate
extension GameViewController: StoreManagerDelegate {
    /// 更新总收入
    ///
    /// - Parameter income: 总收入
    func didUpdateTotalIncome(income: Int) {
        totalIncomeLabel.text = "\(income)"
    }
}
