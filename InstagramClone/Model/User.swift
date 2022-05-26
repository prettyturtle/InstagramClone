//
//  User.swift
//  InstagramClone
//
//  Created by yc on 2022/04/11.
//

import Foundation

struct User: Codable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let name: String?
    let nickName: String
    let profileImageURLString: String?
    let feed: [String]
    let follower: [String]
    let following: [String]
    let like: [String]
    
    var profileImageURL: URL? { URL(string: profileImageURLString ?? "") }
    
    static let mockUser = User(
        id: "BD43F628-3017-473D-A521-B9F768BC077A",
        name: "이영찬",
        nickName: "20._.chan",
        profileImageURLString: "https://i.picsum.photos/id/503/2560/1440.jpg?hmac=IdEK6g8OmWZiHZYfiwldM9qYPcd8PpBSSSj-mYoegkU",
        feed: [],
        follower: [],
        following: [],
        like: []
    )
}
