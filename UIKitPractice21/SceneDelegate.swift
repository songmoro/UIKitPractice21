//
//  SceneDelegate.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        let shopViewController = UINavigationController(rootViewController: ShopViewController(viewModel: ShopViewModel()))
        
        tabBarController.setViewControllers([shopViewController], animated: true)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
