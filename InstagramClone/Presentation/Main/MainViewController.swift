//
//  MainViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit
import SnapKit
import Toast

class MainViewController: UIViewController {
    
    private let firebaseDBManager = FirebaseDBManager()
    
    private let feedTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private var feeds = [Feed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
        getFeeds()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count + 1
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
            
            let feed = feeds[indexPath.row - 1]
            cell.setupView(feed: feed)
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension MainViewController: FeedTableViewCellDelegate {
    func deleteFeed(feed: Feed) {
        firebaseDBManager.deleteFeed(feed: feed) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.view.makeToast("피드 삭제 성공!")
                self.getFeeds()
            case .failure(let error):
                print("ERROR: MainViewController - FeedTableViewCellDelegate - deleteFeed - \(error.localizedDescription)")
                self.view.makeToast("피드 삭제를 실패했습니다")
            }
        }
    }
    
    func showAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
}

extension MainViewController: UploadFeedViewDelegate {
    func didEndUploadFeed() {
        view.makeToast("피드 등록 완료!")
    }
}

private extension MainViewController {
    @objc func beginRefresh() {
        getFeeds()
    }
    @objc func didTapPlusBarButton() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let feedAction = UIAlertAction(
            title: "게시물",
            style: .default
        ) { [weak self] _ in
            let rootViewController = UploadFeedViewController()
            rootViewController.delegate = self
            let uploadFeedViewController = UINavigationController(rootViewController: rootViewController)
            uploadFeedViewController.modalPresentationStyle = .fullScreen
            self?.present(uploadFeedViewController, animated: true)
        }
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
    func getFeeds() {
        firebaseDBManager.readFeed(
            user: User.mockUser) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let feeds):
                    self.feeds = feeds
                    self.feedTableView.reloadData()
                    self.refreshControl.endRefreshing()
                case .failure(let error):
                    print("ERROR: MainViewController - getFeeds - \(error.localizedDescription)")
                    self.view.makeToast("피드를 불러오는데 실패했습니다")
                }
            }
    }
    func setupNavigationBar() {
        let logoBarButton = UIBarButtonItem()
        logoBarButton.image = UIImage(named: "logo")
        
        let plusBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: self,
            action: #selector(didTapPlusBarButton)
        )
        
        navigationItem.leftBarButtonItem = logoBarButton
        navigationItem.rightBarButtonItem = plusBarButtonItem
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        feedTableView.refreshControl = refreshControl
        
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
