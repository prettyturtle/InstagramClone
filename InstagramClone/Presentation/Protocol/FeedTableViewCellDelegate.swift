//
//  FeedTableViewCellDelegate.swift
//  InstagramClone
//
//  Created by yc on 2022/04/16.
//

import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func showAlert(_ alertController: UIAlertController)
    func deleteFeed(feed: Feed)
    func modifyFeed(feed: Feed)
}
