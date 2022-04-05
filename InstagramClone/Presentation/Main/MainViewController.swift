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
extension MainViewController {
    @objc func didTapPlusBarButton() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let feedAction = UIAlertAction(
            title: "게시물",
            style: .default
        )
        let storyAction = UIAlertAction(
            title: "스토리",
            style: .default
        )
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        [
            feedAction,
            storyAction,
            cancelAction
        ].forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}
private extension MainViewController {
    func setupNavigationBar() {
        logoBarButton.image = UIImage(named: "logo")
        navigationItem.leftBarButtonItem = logoBarButton
        
        let plusBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: self,
            action: #selector(didTapPlusBarButton)
        )
        navigationItem.rightBarButtonItem = plusBarButtonItem
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
