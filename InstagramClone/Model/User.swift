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
    static let mockUser2 = User(
        id: "3608CA92-C13D-4DD5-9AF0-E6CD8DAB6930",
        name: "김승헌",
        nickName: "mult_chord.sh",
        profileImageURLString: "https://i.picsum.photos/id/989/2560/1440.jpg?hmac=piUBx_I3dNIviu-fAG96S-SuXDRVqdf8Q2-rJvR4CjM",
        feed: [],
        follower: [],
        following: [],
        like: []
    )
    static let mockUser3 = User(
        id: "95749E80-3515-4964-9AA2-705852FB1776",
        name: "정민규",
        nickName: "min._._.gyu",
        profileImageURLString: "https://i.picsum.photos/id/551/2560/1440.jpg?hmac=1rnt3o8xNDJvEf_jaFv21Yo3A2EvxlCFBlL_PIkXpZU",
        feed: [],
        follower: [],
        following: [],
        like: []
    )
}
