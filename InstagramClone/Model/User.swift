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
    private let profileImageURLString: String
    let feed: [Feed]
    let follower: [User]
    let following: [User]
    let like: [Feed]
    
    var profileImageURL: URL? { URL(string: profileImageURLString) }
}
