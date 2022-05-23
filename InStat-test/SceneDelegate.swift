//
//  SceneDelegate.swift
//  InStat-test
//
//  Created by Денис Рубцов on 20.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        window?.rootViewController = UINavigationController(rootViewController: LeaguesViewController())
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
    }

}

