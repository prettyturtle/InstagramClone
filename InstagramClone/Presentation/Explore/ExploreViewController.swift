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
    private let refreshControl = UIRefreshControl()
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var exploreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCollectionViewCell", for: indexPath)
        cell.backgroundColor = [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6].randomElement()!
        return cell
    }
}

private extension ExploreViewController {
    @objc func beginRefresh(_ sender: UIRefreshControl) {
        print("beginRefresh!!")
        sender.endRefreshing()
    }
}

private extension ExploreViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        
        navigationController?.hidesBarsOnSwipe = true
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.titleView = searchController.searchBar
        
        refreshControl.addTarget(self, action: #selector(beginRefresh(_:)), for: .valueChanged)
        exploreCollectionView.refreshControl = refreshControl
        
        exploreCollectionView.dataSource = self
        exploreCollectionView.delegate = self
        exploreCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ExploreCollectionViewCell")
    }
    func layout() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
