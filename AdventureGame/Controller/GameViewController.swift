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
    
    required init?(coder aDecoder: NSCoder) {
        backgroundView = UIScrollView(frame: CGRect.zero)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
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
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        backgroundView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        backgroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        for x in 0...10 {
            let storeView = StoreView(frame: CGRect(x: x%2==0 ? 50 : 400, y: x/2*90 + 50, width: 300, height: 80))
            backgroundView.addSubview(storeView)
            storeView.updateName(name: "name\(x)")
        }
    }
}
