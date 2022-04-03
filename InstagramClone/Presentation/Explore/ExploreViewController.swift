//
//  ExploreViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/04.
//

import UIKit
import SnapKit

class ExploreViewController: UIViewController {
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
}

private extension ExploreViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.titleView = searchController.searchBar
    }
    func layout() {
        
    }
}
