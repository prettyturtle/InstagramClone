//
//  FeedImageCollectionViewCell.swift
//  InstagramClone
//
//  Created by yc on 2022/04/14.
//

import UIKit
import SnapKit

class FeedImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeedImageCollectionViewCell"
    
    private let feedImageView = UIImageView()
    
    override func prepareForReuse() {
        feedImageView.image = nil
    }
    
    func setupView(image: UIImage?) {
        attribute()
        layout()
        feedImageView.image = image
    }
}

private extension FeedImageCollectionViewCell {
    func attribute() {
        feedImageView.backgroundColor = .systemBackground
        feedImageView.contentMode = .scaleAspectFit
    }
    func layout() {
        contentView.addSubview(feedImageView)
        feedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
