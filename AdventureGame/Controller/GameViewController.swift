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
        
        StoreManager.shared.addObserver(self, forKeyPath: "totalIncome", options: .new, context: nil)
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
    fileprivate func prepareUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(30)
        }
        backgroundView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        backgroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(totalIncomeLabel)
        totalIncomeLabel.snp.makeConstraints { (make) in
            make.top.right.equalTo(10)
        }
        
        for x in 0...MaxStoreIndex {
            let storeView = StoreView(frame: CGRect(x: x%2==0 ? 50 : 400, y: x/2*90, width: 300, height: 80))
            backgroundView.addSubview(storeView)
            storeView.update(model: StoreManager.shared.getModel(index: x))
        }
    }
}

// MARK: - KVO
extension GameViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let newValue = change?[.newKey]
        if keyPath == "totalIncome" {
            guard let incomeString = newValue as? String else { return }
            totalIncomeLabel.text = incomeString
        }
    }
}
