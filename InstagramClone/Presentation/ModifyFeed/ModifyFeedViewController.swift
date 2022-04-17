//
//  ModifyFeedViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/17.
//

import UIKit
import SnapKit

class ModifyFeedViewController: UIViewController {
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var selectedImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private let descriptionTextView = UITextView()
    
    var feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
        setupView(feed: feed)
    }
}

extension ModifyFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ModifyFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.imageURL.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModifyFeedImageCollectionViewCell.identifier, for: indexPath) as? ModifyFeedImageCollectionViewCell else { return UICollectionViewCell() }
        setImage(url: feed.imageURL[indexPath.item]) { image in
            cell.setupView(image: image)
        }
        return cell
    }
}

private extension ModifyFeedViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton!")
    }
}

private extension ModifyFeedViewController {
    func setupView(feed: Feed) {
        descriptionTextView.text = feed.description
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
    func setupNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapLeftBarButton)
        )
        let rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        leftBarButtonItem.tintColor = .label
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        collectionViewLayout.scrollDirection = .horizontal
        selectedImageCollectionView.isPagingEnabled = true
        selectedImageCollectionView.dataSource = self
        selectedImageCollectionView.delegate = self
        selectedImageCollectionView.register(
            ModifyFeedImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ModifyFeedImageCollectionViewCell.identifier
        )
        
        descriptionTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
    }
    func layout() {
        [
            selectedImageCollectionView,
            descriptionTextView
        ].forEach { view.addSubview($0) }
        
        selectedImageCollectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(selectedImageCollectionView.snp.width)
        }
        descriptionTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(selectedImageCollectionView.snp.bottom).offset(16.0)
            $0.height.equalTo(48.0)
        }
    }
}
