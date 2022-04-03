//
//  StoryCollectionViewCell.swift
//  InstagramClone
//
//  Created by yc on 2022/04/02.
//

import UIKit
import SnapKit

class StoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "StoryCollectionViewCell"
    
    private let userImageBorderView = UIImageView()
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    
    func setupView() {
        layout()
        attribute()
    }
}

private extension StoryCollectionViewCell {
    func attribute() {
        userNameLabel.text = "20._.chan"
        
        userImageView.layer.cornerRadius = ((UIScreen.main.bounds.width / 5.0) - 6.0) / 2.0
        userImageView.backgroundColor = .secondarySystemBackground
        
        userImageBorderView.image = UIImage(named: "storyBackground")
        userImageBorderView.clipsToBounds = true
        userImageBorderView.layer.cornerRadius = (UIScreen.main.bounds.width / 5.0) / 2.0
        
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .label
        userNameLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
    }
    func layout() {
        userImageBorderView.addSubview(userImageView)
        userImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3.0)
        }
        
        [
            userImageBorderView,
            userNameLabel
        ].forEach { contentView.addSubview($0) }
        
        userImageBorderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(userImageBorderView.snp.width)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageBorderView.snp.bottom).offset(4.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
