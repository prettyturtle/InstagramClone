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
                        name: nil,
                        nickName: nickName,
                        profileImageURLString: nil,
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
}
