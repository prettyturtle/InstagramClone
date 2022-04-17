//
//  ModifyFeedImageCollectionViewCell.swift
//  InstagramClone
//
//  Created by yc on 2022/04/17.
//

import UIKit
import SnapKit

class ModifyFeedImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ModifyFeedImageCollectionViewCell"
    
    private let feedImageView = UIImageView()
    
    func setupView(image: UIImage?) {
        attribute()
        layout()
        feedImageView.image = image
    }
}
private extension ModifyFeedImageCollectionViewCell {
    func attribute() {
        feedImageView.clipsToBounds = true
        feedImageView.backgroundColor = .secondarySystemBackground
    }
    func layout() {
        contentView.addSubview(feedImageView)
        feedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
