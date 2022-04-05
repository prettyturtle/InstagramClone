//
//  AccountViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/04.
//

import UIKit
import SnapKit

class AccountViewController: UIViewController {
    
    private let profileView = UIView()
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let postStackView = UIStackView()
    private let postCountLabel = UILabel()
    private let postLabel = UILabel()
    private let followerStackView = UIStackView()
    private let followerCountLabel = UILabel()
    private let followerLabel = UILabel()
    private let followingStackView = UIStackView()
    private let followingCountLabel = UILabel()
    private let followingLabel = UILabel()
    private let allStackView = UIStackView()
    
    private let profileModifyButton = UIButton()
    private let recommendedFriendButton = UIButton()
    
    private let myFeedView = UIView()
    private let separatorView = UIView()
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var myFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}
extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
extension AccountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFeedCollectionViewCell", for: indexPath)
        cell.backgroundColor = [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6].randomElement()!
        return cell
    }
}

private extension AccountViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        userNameLabel.text = "이영찬"
        postCountLabel.text = "0"
        followerCountLabel.text = "182"
        followingCountLabel.text = "345"
        
        profileImageView.backgroundColor = .secondarySystemBackground
        profileImageView.layer.cornerRadius = 40.0
        userNameLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        
        postCountLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        postCountLabel.textAlignment = .center
        postLabel.text = "게시물"
        postLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        postLabel.textAlignment = .center
        [ postCountLabel, postLabel ].forEach { postStackView.addArrangedSubview($0) }
        postStackView.axis = .vertical
        postStackView.spacing = 4.0
        
        followerCountLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        followerCountLabel.textAlignment = .center
        followerLabel.text = "팔로워"
        followerLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        followerLabel.textAlignment = .center
        [ followerCountLabel, followerLabel ].forEach { followerStackView.addArrangedSubview($0) }
        followerStackView.axis = .vertical
        followerStackView.spacing = 4.0
        
        followingCountLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        followingCountLabel.textAlignment = .center
        followingLabel.text = "팔로잉"
        followingLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        followingLabel.textAlignment = .center
        [ followingCountLabel, followingLabel ].forEach { followingStackView.addArrangedSubview($0) }
        followingStackView.axis = .vertical
        followingStackView.spacing = 4.0
        
        [
            postStackView,
            followerStackView,
            followingStackView
        ].forEach { allStackView.addArrangedSubview($0) }
        allStackView.distribution = .fillEqually
        
        profileModifyButton.setTitle("프로필 편집", for: .normal)
        profileModifyButton.setTitleColor(.label, for: .normal)
        profileModifyButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        profileModifyButton.layer.borderColor = UIColor.secondarySystemFill.cgColor
        profileModifyButton.layer.borderWidth = 2.0
        profileModifyButton.layer.cornerRadius = 4.0
        
        recommendedFriendButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        recommendedFriendButton.layer.borderColor = UIColor.secondarySystemFill.cgColor
        recommendedFriendButton.layer.borderWidth = 2.0
        recommendedFriendButton.layer.cornerRadius = 4.0
        
        separatorView.backgroundColor = .separator
        myFeedCollectionView.dataSource = self
        myFeedCollectionView.delegate = self
        myFeedCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyFeedCollectionViewCell")
    }
    func layout() {
        let commonInset: CGFloat = 16.0
        [
            profileImageView,
            userNameLabel,
            allStackView,
            profileModifyButton,
            recommendedFriendButton
        ].forEach { profileView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(80.0)
            $0.leading.top.equalToSuperview().inset(commonInset)
        }
        userNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(profileImageView.snp.bottom).offset(8.0)
        }
        allStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
        profileModifyButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonInset)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8.0)
            $0.height.equalTo(32.0)
            $0.bottom.equalToSuperview()
        }
        recommendedFriendButton.snp.makeConstraints {
            $0.top.equalTo(profileModifyButton.snp.top)
            $0.leading.equalTo(profileModifyButton.snp.trailing).offset(4.0)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.size.equalTo(32.0)
            $0.bottom.equalTo(profileModifyButton.snp.bottom)
        }
        
        [
            separatorView,
            myFeedCollectionView
        ].forEach { myFeedView.addSubview($0) }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.leading.top.trailing.equalToSuperview()
        }
        myFeedCollectionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [
            profileView,
            myFeedView
        ].forEach { view.addSubview($0) }
        profileView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        myFeedView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(commonInset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    func setupNavigationBar() {
        let leftBarButtonCustomView = UILabel()
        leftBarButtonCustomView.text = "20._.chan"
        leftBarButtonCustomView.font = .systemFont(ofSize: 24.0, weight: .bold)
        leftBarButtonCustomView.textColor = .label
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonCustomView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let plusBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: nil,
            action: nil
        )
        let optionBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItems = [optionBarButtonItem, plusBarButtonItem]
    }
}
