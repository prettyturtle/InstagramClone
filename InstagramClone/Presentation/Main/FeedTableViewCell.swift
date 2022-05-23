//
//  FeedTableViewCell.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit
import SnapKit

class FeedTableViewCell: UITableViewCell {
    static let identifier = "FeedTableViewCell"
    
    private let feedHeaderView = UIView()
    private let userImageView = UIImageView()
    private let userNameAndLocationStackView = UIStackView()
    private let userNameLabel = UILabel()
    private let locationLabel = UILabel()
    private let meatBallMenuButton = UIButton()
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var feedImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    private let directMessageButton = UIButton()
    private let bookmarkButton = UIButton()
    private let iconView = UIView()
    
    private let likePeopleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let feedDescriptionView = UIView()
    
    private let dateLabel = UILabel()
    
    private var feedImages = [UIImage?]()
    private var feed: Feed?
    
    weak var delegate: FeedTableViewCellDelegate?
    
    private let firebaseAuthManager = FirebaseAuthManager()
    
    func setupView(feed: Feed) {
        attribute()
        layout()
        tapEvent()
        
        self.feed = feed
        
        userNameLabel.text = feed.user.nickName
        locationLabel.text = feed.location
        likePeopleLabel.text = !feed.likeUser.isEmpty ? "\(feed.likeUser.first!.nickName)님 외 \(feed.likeUser.count)명이 좋아합니다" : ""
        descriptionLabel.text = "\(feed.user.nickName) \(feed.description)"
        dateLabel.text = feed.date
        
        setImage(url: feed.user.profileImageURL) { [weak self] image in
            guard let self = self else { return }
            self.userImageView.image = image
        }
        
        setImages(urls: feed.imageURL) { [weak self] images in
            guard let self = self else { return }
            self.feedImages = images
            self.feedImageCollectionView.reloadData()
        }
    }
}

extension FeedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension FeedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCollectionViewCell.identifier, for: indexPath) as? FeedImageCollectionViewCell else { return UICollectionViewCell() }
        cell.setupView(image: feedImages[indexPath.item])
        return cell
    }
}

private extension FeedTableViewCell {
    @objc func didDoubleTapFeedImageView() {
        print("didDoubleTapFeedImageView!!")
    }
    @objc func didTapLikeButton() {
        print("didTapLikeButton")
    }
    @objc func didTapMeatBallMenuButton() {
        guard let feed = feed else { return }
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let modifyAction = UIAlertAction(
            title: "수정",
            style: .default
        ) { [weak self] _ in
            self?.delegate?.modifyFeed(feed: feed)
        }
        let deleteAction = UIAlertAction(
            title: "삭제",
            style: .destructive
        ) { [weak self] _ in
            self?.delegate?.deleteFeed(feed: feed)
        }
        let shareAction = UIAlertAction(title: "공유", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        firebaseAuthManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            if feed.user == user {
                [
                    modifyAction,
                    deleteAction,
                    cancelAction
                ].forEach { alertController.addAction($0) }
            } else {
                [
                    shareAction,
                    cancelAction
                ].forEach { alertController.addAction($0) }
            }
            
            self.delegate?.showAlert(alertController)
        }
    }
}

private extension FeedTableViewCell {
    func setImages(urls: [URL?], completionHandler: @escaping ([UIImage?]) -> Void) {
        let urls = urls.compactMap { $0 }
        DispatchQueue.global(qos: .background).async {
            do {
                let datas = try urls.map { try Data(contentsOf: $0) }
                let images = datas.map { UIImage(data: $0) }
                DispatchQueue.main.async {
                    completionHandler(images)
                }
            } catch {
                print("ERROR: FeedTableViewCell - setImages - do catch - \(error.localizedDescription)")
            }
        }
    }
    func setImage(url: URL?, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = url else { return }
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            } catch {
                print("ERROR: FeedTableViewCell - setImage - do catch - \(error.localizedDescription)")
            }
        }
    }
    
    func tapEvent() {
        doubleTapLikeEvent()
        tapLikeButton()
        tapMeatBallMenuButton()
    }
    func doubleTapLikeEvent() {
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(didDoubleTapFeedImageView)
        )
        doubleTap.numberOfTapsRequired = 2
        feedImageCollectionView.addGestureRecognizer(doubleTap)
    }
    func tapLikeButton() {
        likeButton.addTarget(
            self,
            action: #selector(didTapLikeButton),
            for: .touchUpInside
        )
    }
    func tapMeatBallMenuButton() {
        meatBallMenuButton.addTarget(
            self,
            action: #selector(didTapMeatBallMenuButton),
            for: .touchUpInside
        )
    }
    func attribute() {
        userImageView.backgroundColor = .secondarySystemBackground
        userImageView.layer.cornerRadius = 22.0
        userImageView.clipsToBounds = true
        userNameAndLocationStackView.axis = .vertical
        userNameAndLocationStackView.spacing = 2.0
        userNameLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        locationLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        meatBallMenuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        collectionViewLayout.scrollDirection = .horizontal
        feedImageCollectionView.isPagingEnabled = true
        feedImageCollectionView.dataSource = self
        feedImageCollectionView.delegate = self
        feedImageCollectionView.register(
            FeedImageCollectionViewCell.self,
            forCellWithReuseIdentifier: FeedImageCollectionViewCell.identifier
        )
        
        likeButton.setImage(systemName: "heart")
        commentButton.setImage(systemName: "message")
        directMessageButton.setImage(systemName: "paperplane")
        bookmarkButton.setImage(systemName: "bookmark")
        
        likePeopleLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        descriptionLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        descriptionLabel.numberOfLines = 3
        
        dateLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        dateLabel.textColor = .secondaryLabel
    }
    func layout() {
        let commonInset: CGFloat = 16.0
        let userImageSize: CGFloat = 44.0
        let iconSize: CGFloat = 24.0
        
        [
            userNameLabel,
            locationLabel
        ].forEach { userNameAndLocationStackView.addArrangedSubview($0) }
        
        [
            userImageView,
            userNameAndLocationStackView,
            meatBallMenuButton
        ].forEach { feedHeaderView.addSubview($0) }
        
        [
            likeButton,
            commentButton,
            directMessageButton,
            bookmarkButton
        ].forEach { iconView.addSubview($0) }
        
        likeButton.snp.makeConstraints {
            $0.size.equalTo(iconSize)
            $0.leading.top.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview()
        }
        commentButton.snp.makeConstraints {
            $0.size.equalTo(iconSize)
            $0.leading.equalTo(likeButton.snp.trailing).offset(commonInset)
            $0.top.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview()
        }
        directMessageButton.snp.makeConstraints {
            $0.size.equalTo(iconSize)
            $0.leading.equalTo(commentButton.snp.trailing).offset(commonInset)
            $0.top.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview()
        }
        bookmarkButton.snp.makeConstraints {
            $0.size.equalTo(iconSize)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview()
        }
        
        [
            likePeopleLabel,
            descriptionLabel
        ].forEach { feedDescriptionView.addSubview($0) }
        
        likePeopleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(likePeopleLabel.snp.bottom).offset(commonInset / 2)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset / 2)
        }
        
        [
            feedHeaderView,
            feedImageCollectionView,
            iconView,
            feedDescriptionView,
            dateLabel
        ].forEach { contentView.addSubview($0) }
        
        userImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(commonInset)
            $0.size.equalTo(userImageSize)
        }
        userNameAndLocationStackView.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(commonInset)
            $0.centerY.equalTo(userImageView.snp.centerY)
        }
        meatBallMenuButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(commonInset)
        }
        feedHeaderView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        feedImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(feedHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(feedImageCollectionView.snp.width)
        }
        iconView.snp.makeConstraints {
            $0.top.equalTo(feedImageCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        feedDescriptionView.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(feedDescriptionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }
}
