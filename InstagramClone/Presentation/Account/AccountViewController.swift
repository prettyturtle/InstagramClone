//
//  AccountViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/04.
//

import UIKit
import PhotosUI
import SnapKit
import Toast

class AccountViewController: UIViewController {
    
    private let profileView = UIView()
    private let profileImageView = UIImageView()
    private let profileImagePickerButton = UIButton()
    private let profileImagePlusIconView = UILabel()
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
    
    private var profileImage: UIImage?
    
    private let firebaseDBManager = FirebaseDBManager()
    private let firebaseAuthManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseAuthManager().getCurrentUser() // 로그인 확인용
        fetchUser()
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
extension AccountViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let imageProvider = results.first?.itemProvider {
            if imageProvider.canLoadObject(ofClass: UIImage.self) {
                imageProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.firebaseAuthManager.getCurrentUser { user in
                                self.firebaseDBManager.uploadUserProfileImage(image: image) { result in
                                    switch result {
                                    case .success(let url):
                                        self.firebaseDBManager.updateUserProfileImage(user: user, url: url) { result in
                                            switch result {
                                            case .success(_):
                                                self.view.makeToast("프로필 사진 업로드 성공!")
                                            case .failure(_):
                                                self.view.makeToast("프로필 사진 업로드 실패")
                                            }
                                        }
                                    case .failure(let error):
                                        print("ERROR: AccountViewController - PHPickerViewControllerDelegate - \(error.localizedDescription)")
                                    }
                                }
                            }
                            self.profileImageView.image = image
                            self.profileImage = image
                        }
                    }
                    if let error = error {
                        print("ERROR - AccountViewController - PHPickerViewControllerDelegate - \(error.localizedDescription)")
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}

private extension AccountViewController {
    func fetchUser() {
        firebaseAuthManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            self.userNameLabel.text = user.name
            self.postCountLabel.text = "\(user.feed.count)"
            self.followerCountLabel.text = "\(user.follower.count)"
            self.followingCountLabel.text = "\(user.following.count)"
            self.updateNavigationTitle(nickName: user.nickName)
            guard let url = URL(string: user.profileImageURLString ?? ""),
                  let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            self.profileImageView.image = image
        }
    }
    func updateNavigationTitle(nickName: String) {
        let leftBarButtonCustomView = UILabel()
        leftBarButtonCustomView.text = nickName
        leftBarButtonCustomView.font = .systemFont(ofSize: 24.0, weight: .bold)
        leftBarButtonCustomView.textColor = .label
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonCustomView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

private extension AccountViewController {
    @objc func didTapProfileImagePickerButton() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let imagePickerViewController = PHPickerViewController(configuration: config)
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true)
    }
    @objc func didTapOptionBarButton() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let signUpAction = UIAlertAction(
            title: "회원가입",
            style: .default
        ) { [weak self] _ in
            let rootVC = MakeNameViewController()
            let makeNickNameVC = UINavigationController(rootViewController: rootVC)
            makeNickNameVC.modalPresentationStyle = .fullScreen
            self?.present(makeNickNameVC, animated: true)
        }
        let signOutAction = UIAlertAction(
            title: "로그아웃",
            style: .destructive
        ) { [weak self] _ in
            self?.firebaseAuthManager.signOut(completionHandler: { result in
                switch result {
                case .success(_):
                    print("로그아웃 성공")
                    let signInVC = SignInViewController()
                    signInVC.modalPresentationStyle = .fullScreen
                    self?.present(signInVC, animated: true)
                case .failure(let error):
                    print("로그아웃 실패: \(error.localizedDescription)")
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [
            signUpAction,
            signOutAction,
            cancelAction
        ].forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}

private extension AccountViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        
        profileImageView.backgroundColor = .secondarySystemBackground
        profileImageView.layer.cornerRadius = 40.0
        profileImageView.clipsToBounds = true
        
        profileImagePickerButton.layer.cornerRadius = 40.0
        profileImagePickerButton.clipsToBounds = true
        profileImagePickerButton.addTarget(
            self,
            action: #selector(didTapProfileImagePickerButton),
            for: .touchUpInside
        )
        profileImagePlusIconView.text = "+"
        profileImagePlusIconView.font = .systemFont(ofSize: 20.0, weight: .semibold)
        profileImagePlusIconView.textColor = .white
        profileImagePlusIconView.textAlignment = .center
        profileImagePlusIconView.backgroundColor = .systemBlue
        profileImagePlusIconView.clipsToBounds = true
        profileImagePlusIconView.layer.cornerRadius = 12.0
        
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
            profileImagePickerButton,
            profileImagePlusIconView,
            userNameLabel,
            allStackView,
            profileModifyButton,
            recommendedFriendButton
        ].forEach { profileView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(80.0)
            $0.leading.top.equalToSuperview().inset(commonInset)
        }
        profileImagePickerButton.snp.makeConstraints {
            $0.size.equalTo(profileImageView.snp.width)
            $0.center.equalTo(profileImageView.snp.center)
        }
        profileImagePlusIconView.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
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
        let plusBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: nil,
            action: nil
        )
        let optionBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(didTapOptionBarButton)
        )
        
        navigationItem.rightBarButtonItems = [optionBarButtonItem, plusBarButtonItem]
    }
}
