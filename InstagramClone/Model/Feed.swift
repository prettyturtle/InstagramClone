//
//  Feed.swift
//  InstagramClone
//
//  Created by yc on 2022/04/11.
//

import Foundation

struct Feed: Codable {
    let id: String
    let user: User
    let location: String
    private let imageURLString: [String]
    let likeUser: [User]
    let description: String
    private let createDate: Date
    
    var imageURL: [URL?] {
        imageURLString.map { URL(string: $0) }
    }
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: createDate)
    }
}
