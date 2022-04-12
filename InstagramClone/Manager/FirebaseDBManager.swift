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
                                    completionHandler(.success(()))
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
}

