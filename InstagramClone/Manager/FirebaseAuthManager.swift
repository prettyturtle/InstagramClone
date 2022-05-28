//
//  FirebaseAuthManager.swift
//  InstagramClone
//
//  Created by yc on 2022/04/26.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthManager {
    private let auth = Auth.auth()
    private let firebaseDBManager = FirebaseDBManager()
    
    func signUp(
        email: String,
        password: String,
        name: String,
        nickName: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        auth.createUser(
            withEmail: email,
            password: password) { result, error in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                if let result = result {
                    let newUser = User(
                        id: result.user.uid,
                        name: name,
                        nickName: nickName,
                        profileImageURLString: "",
                        feed: [],
                        follower: [],
                        following: [],
                        like: []
                    )
                    firebaseDBManager.createUser(user: newUser) { result in
                        switch result {
                        case .success(_):
                            completionHandler(.success(()))
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                }
            }
    }
    
    func checkSignInUser() -> Bool {
        if auth.currentUser == nil { return false }
        else { return true }
    }
    func getCurrentUser() {
        guard let currentUserID = auth.currentUser?.uid else { return }
        firebaseDBManager.readUser(id: currentUserID) { result in
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getCurrentUser(completionHandler: @escaping (User) -> Void) {
        guard let currentUserID = auth.currentUser?.uid else { return }
        firebaseDBManager.readUser(id: currentUserID) { result in
            switch result {
            case .success(let user):
                print(user)
                completionHandler(user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func signIn(
        email: String,
        password: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            } else {
                completionHandler(.success(()))
            }
        }
    }
    func signOut(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func likeFeed(
        feedID: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let userID = auth.currentUser?.uid else { return }
        firebaseDBManager.updateUserLike(userID: userID, feedID: feedID) { result in
            switch result {
            case .success(_):
                completionHandler(.success(()))
                return
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
    
    func unlikeFeed(
        feedID: String,
        completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let userID = auth.currentUser?.uid else { return }
        firebaseDBManager.updateUserUnlike(userID: userID, feedID: feedID) { result in
            switch result {
            case .success(_):
                completionHandler(.success(()))
                return
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
}
