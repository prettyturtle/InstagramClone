//
//  TabBarController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = .label
        
        let tabBarItems: [UIViewController] = TabBar.allCases.map {
            let viewController = $0.viewController
            viewController.tabBarItem = $0.tabBarItem
            return viewController
        }
        
        viewControllers = tabBarItems
    }
}
