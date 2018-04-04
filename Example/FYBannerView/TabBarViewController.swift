//
//  TabBarViewController.swift
//  FYBannerView_Example
//
//  Created by 武飞跃 on 2018/1/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstVC = TableHeadViewController()
        let secondVC = TableCellViewController()
        
        let vcs = [firstVC, secondVC]
        
        let itemNames = ["First", "Second"]
        for (i, vc) in vcs.enumerated() {
            vc.tabBarItem.title = itemNames[i]
            vc.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10)], for: .normal)
            vc.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.black], for: .selected)
        }
        
        viewControllers = vcs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


