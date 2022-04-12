//
//  User.swift
//  InstagramClone
//
//  Created by yc on 2022/04/11.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let nickName: String
    let profileImageURLString: String
    let feed: [Feed]
    let follower: [User]
    let following: [User]
    let like: [Feed]
    
    var profileImageURL: URL? { URL(string: profileImageURLString) }
    
    static let mockUser = User(
        id: UUID().uuidString,
        name: "이영찬",
        nickName: "20._.chan",
        profileImageURLString: "https://i.picsum.photos/id/503/2560/1440.jpg?hmac=IdEK6g8OmWZiHZYfiwldM9qYPcd8PpBSSSj-mYoegkU",
        feed: [],
        follower: [],
        following: [],
        like: []
    )
}
