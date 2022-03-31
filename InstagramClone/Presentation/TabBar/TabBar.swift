//
//  TabBar.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit

enum TabBar: CaseIterable {
    case main
    case search
    case reels
    case shop
    case account
    
    var viewController: UIViewController {
        switch self {
        case .main:
            return UINavigationController(rootViewController: MainViewController())
        case .search:
            return UIViewController()
        case .reels:
            return UIViewController()
        case .shop:
            return UIViewController()
        case .account:
            return UIViewController()
        }
    }
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        case .search:
            return UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        case .reels:
            return UITabBarItem(title: nil, image: UIImage(systemName: "play.square"), selectedImage: UIImage(systemName: "play.square.fill"))
        case .shop:
            return UITabBarItem(title: nil, image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        case .account:
            return UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        }
    }
}
