//
//  StoryTableViewCell.swift
//  InstagramClone
//
//  Created by yc on 2022/04/02.
//

import UIKit
import SnapKit

class StoryTableViewCell: UITableViewCell {
    static let identifier = "StoryTableViewCell"
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    func setupView() {
        attribute()
        layout()
    }
}

extension StoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 5.0
        return CGSize(width: width, height: width + 20.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
}

extension StoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCollectionViewCell.identifier,
            for: indexPath
        ) as? StoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setupView()
        
        return cell
    }
}

private extension StoryTableViewCell {
    func attribute() {
        collectionViewLayout.scrollDirection = .horizontal
        storyCollectionView.showsHorizontalScrollIndicator = false
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyCollectionView.register(
            StoryCollectionViewCell.self,
            forCellWithReuseIdentifier: StoryCollectionViewCell.identifier
        )
    }
    func layout() {
        contentView.addSubview(storyCollectionView)
        
        storyCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(100.0)
        }
    }
}
