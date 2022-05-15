//
//  SceneDelegate.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        // 로그인이 되어있으면 바로 메인화면으로, 로그인이 되어있지 않다면 로그인 화면으로
        let rootViewController = firebaseAuthManager.checkSignInUser() ? TabBarController() : SignInViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
