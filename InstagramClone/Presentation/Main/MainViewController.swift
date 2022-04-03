//
//  MainViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let logoBarButton = UIBarButtonItem()
    private let feedTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoryTableViewCell.identifier,
                for: indexPath
            ) as? StoryTableViewCell else { return UITableViewCell() }
            
            cell.setupView()
            cell.selectionStyle = .none
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FeedTableViewCell.identifier,
                for: indexPath
            ) as? FeedTableViewCell else { return UITableViewCell() }
            
            cell.setupView()
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
}

private extension MainViewController {
    func setupNavigationBar() {
        logoBarButton.image = UIImage(named: "logo")
        navigationItem.leftBarButtonItem = logoBarButton
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        feedTableView.showsVerticalScrollIndicator = false
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.separatorStyle = .none
        feedTableView.dataSource = self
        feedTableView.register(
            FeedTableViewCell.self,
            forCellReuseIdentifier: FeedTableViewCell.identifier
        )
        feedTableView.register(
            StoryTableViewCell.self,
            forCellReuseIdentifier: StoryTableViewCell.identifier
        )
        
    }
    func layout() {
        view.addSubview(feedTableView)
        feedTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}