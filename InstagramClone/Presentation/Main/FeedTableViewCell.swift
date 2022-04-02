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
    private let feedImageView = UIImageView()
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    private let directMessageButton = UIButton()
    private let bookmarkButton = UIButton()
    private let iconView = UIView()
    
    private let likePeopleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let feedDescriptionView = UIView()
    
    private let dateLabel = UILabel()
    
    func setupView() {
        attribute()
        layout()
    }
}

private extension FeedTableViewCell {
    func attribute() {
        userNameLabel.text = "20._.chan"
        locationLabel.text = "인하대역 스타벅스"
        likePeopleLabel.text = "mult_chord.sh님 외 41명이 좋아합니다"
        descriptionLabel.text = "20._.chan 그들의 얼마나 있으며, 같이, 것이다. 인간이 이성은 인류의 두기 끝에 유소년에게서 있으랴? 뛰노는 기관과 생생하며, 사막이다. 바이며, 보내는 우리의 품었기 피부가 칼이다. 그것을 청춘은 가는 남는 스며들어 않는 곧 이것이다."
        dateLabel.text = "3월 24일"
        
        userImageView.backgroundColor = .systemGray
        userImageView.layer.cornerRadius = 22.0
        userNameAndLocationStackView.axis = .vertical
        userNameAndLocationStackView.spacing = 2.0
        userNameLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        locationLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        meatBallMenuButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        feedImageView.backgroundColor = .secondarySystemBackground
        
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
            feedImageView,
            iconView,
            feedDescriptionView,
            dateLabel
        ].forEach { addSubview($0) }
        
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
        feedImageView.snp.makeConstraints {
            $0.top.equalTo(feedHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(feedImageView.snp.width)
        }
        iconView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom)
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
