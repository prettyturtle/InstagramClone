//
//  FirebaseDBManager.swift
//  InstagramClone
//
//  Created by yc on 2022/04/12.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


struct FirebaseDBManager {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    /// 피드 추가 메서드
    ///
    /// 피드를 추가하면서 피드를 등록한 유저의 피드 정보도 함께 수정된다
    func createFeed(
        uploadFeed: UploadFeed,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        uploadImage(images: uploadFeed.images) { result in
            switch result {
            case .success(let imageURLString):
                let feed = Feed(
                    id: UUID().uuidString,
                    user: uploadFeed.user,
                    location: uploadFeed.location,
                    imageURLString: imageURLString,
                    likeUser: [],
                    description: uploadFeed.description,
                    createDate: Date.now
                )
                
                do {
                    let feedData = try JSONEncoder().encode(feed)
                    if let feedDataDict = try JSONSerialization.jsonObject(with: feedData) as? [String: Any] {
                        db.collection(CollectionType.feed.name)
                            .document(feed.id)
                            .setData(feedDataDict) { error in
                                if let error = error {
                                    print("ERROR: FirebaseDBManager - createFeed - setData - \(error.localizedDescription)")
                                    completionHandler(.failure(error))
                                } else {
                                    updateUserUploadedFeed(userID: feed.user.id, uploadedFeedID: feed.id) { result in
                                        switch result {
                                        case .success(_):
                                            completionHandler(.success(()))
                                        case .failure(let error):
                                            print("ERROR: FirebaseDBManager - createFeed - setData - updateUserUploadedFeed - \(error.localizedDescription)")
                                            completionHandler(.failure(error))
                                        }
                                    }
                                }
                            }
                    }
                } catch {
                    print("ERROR: FirebaseDBManager - createFeed - do catch - \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
                
            case .failure(let error):
                print("ERROR: FirebaseDBManager - createFeed - uploadImage - \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }
    }
    
    /// 피드 이미지 추가 메서드
    func uploadImage(
        images: [UIImage?],
        completionHandler: @escaping (Result<[String], Error>) -> Void
    ) {
        let storageRef = storage.reference()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        var imageURLString = [String]()
        
        _ = images.map { image in
            let filePath = "images/\(UUID().uuidString)"
            let storageChild = storageRef.child(filePath)
            guard let imageData = image?.pngData() else { return }
            
            storageChild.putData(imageData, metadata: metaData) { _, error in
                if let error = error {
                    print("ERROR: FirebaseDBManager - uploadImage - \(error.localizedDescription)")
                    completionHandler(.failure(error))
                } else {
                    print("FirebaseDBManager - uploadImage - 사진 업로드 성공!!")
                    
                    storageChild.downloadURL { url, error in
                        if let url = url?.absoluteString {
                            imageURLString.append(url)
                            if imageURLString.count == images.count {
                                completionHandler(.success(imageURLString))
                            }
                        }
                        if let error = error {
                            print("ERROR: FirebaseDBManager - uploadImage - downloadURL - \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    // TODO: - User의 피드, User가 팔로우 한 사람들의 피드를 가져오기
    func readFeed(
        user: User,
        completionHandler: @escaping (Result<[Feed], Error>) -> Void
    ) {
        var feeds = [Feed]()
        db.collection(CollectionType.feed.name)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    for document in documents {
                        let documentData = document.data()
                        
                        do {
                            let data = try JSONSerialization.data(withJSONObject: documentData)
                            let feed = try JSONDecoder().decode(Feed.self, from: data)
                            feeds.append(feed)
                        } catch {
                            print("ERROR: FirebaseDBManager - readFeed - getDocuments - decode - \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    }
                }
                if let error = error {
                    print("ERROR: FirebaseDBManager - readFeed - getDocuments - \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
                feeds.sort { $0.createDate.compare($1.createDate) == .orderedDescending }
                completionHandler(.success(feeds))
            }
    }
    
    func updateFeed(
        feed: Feed,
        newDescription: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        db.collection(CollectionType.feed.name)
            .document(feed.id)
            .updateData(["description": newDescription] as [String: Any]) { error in
                if let error = error {
                    print("ERROR: FirebaseDBManager - updateFeed - updateData - \(error.localizedDescription)")
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.success(()))
                }
            }
    }
    
    // TODO: - 사진도 함께 삭제하는 기능 추가
    /// 피드를 삭제하는 메서드
    ///
    /// 피드를 삭제할 때 유저의 피드 정보에 있는 피드도 함께 삭제한다
    func deleteFeed(
        feed: Feed,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        db.collection(CollectionType.feed.name)
            .document(feed.id)
            .delete { error in
                if let error = error {
                    completionHandler(.failure(error))
                    print("ERROR: FirebaseDBManager - deleteFeed - \(error.localizedDescription)")
                } else {
                    updateUserDeletedFeed(userID: feed.user.id, deletedFeedID: feed.id) { result in
                        switch result {
                        case .success(_):
                            completionHandler(.success(()))
                        case .failure(let error):
                            print("ERROR: FirebaseDBManager - deleteFeed - updateUserDeletedFeed - \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    }
                }
            }
    }
    
    // MARK: - User
    func createUser(user: User, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userData = try JSONEncoder().encode(user)
            if let userDataDict = try JSONSerialization.jsonObject(with: userData) as? [String: Any] {
                db.collection(CollectionType.user.name)
                    .document(user.id)
                    .setData(userDataDict) { error in
                        if let error = error {
                            print("ERROR: FirebaseDBManager - createUser - \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        } else {
                            completionHandler(.success(()))
                        }
                    }
            }
        } catch {
            print("ERROR: FirebaseDBManager - createUser - do catch - \(error.localizedDescription)")
            completionHandler(.failure(error))
        }
    }
    
    /// 피드가 업로드 되면 유저의 피드 정보에 추가하는 메서드
    func updateUserUploadedFeed(
        userID: String,
        uploadedFeedID: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        db.collection(CollectionType.user.name)
            .document(userID)
            .getDocument { snapshot, error in
                if let error = error {
                    print("ERROR: FirebaseDBManager - updateUserUploadedFeed - getDocument - \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
                if let snapshot = snapshot {
                    guard let data = snapshot.data(),
                          let currentFeeds = data["feed"] as? [String] else { return }
                    db.collection(CollectionType.user.name)
                        .document(userID)
                        .updateData(
                            [
                                "feed": currentFeeds + [uploadedFeedID]
                            ] as [String: Any]) { error in
                                if let error = error {
                                    print("ERROR: FirebaseDBManager - updateUserUploadedFeed - updateData - \(error.localizedDescription)")
                                    completionHandler(.failure(error))
                                } else {
                                    completionHandler(.success(()))
                                }
                            }
                }
            }
    }
    
    /// 피드가 삭제되면 유저의 피드 정보에서 삭제하는 메서드
    func updateUserDeletedFeed(
        userID: String,
        deletedFeedID: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        db.collection(CollectionType.user.name)
            .document(userID)
            .getDocument { snapshot, error in
                if let error = error {
                    print("ERROR: FirebaseDBManager - updateUserDeletedFeed - getDocument - \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
                if let snapshot = snapshot {
                    guard let data = snapshot.data(),
                          let currentFeeds = data["feed"] as? [String] else { return }
                    let updatedFeeds = currentFeeds.filter { $0 != deletedFeedID }
                    
                    db.collection(CollectionType.user.name)
                        .document(userID)
                        .updateData(
                            [
                                "feed": updatedFeeds
                            ] as [String: Any]) { error in
                                if let error = error {
                                    print("ERROR: FirebaseDBManager - updateUserDeletedFeed - updateData - \(error.localizedDescription)")
                                    completionHandler(.failure(error))
                                } else {
                                    completionHandler(.success(()))
                                }
                            }
                }
            }
    }
}

