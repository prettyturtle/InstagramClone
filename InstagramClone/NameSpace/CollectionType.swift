//
//  CollectionType.swift
//  InstagramClone
//
//  Created by yc on 2022/04/12.
//

import Foundation

enum CollectionType: String {
    case feed = "Feed"
    case user = "User"
    
    var name: String { self.rawValue }
}
