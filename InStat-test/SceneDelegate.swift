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
        
        let assembler = Assembler()
        let router = Router(assembler: assembler)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let leaguesScreen = assembler.createLeaguesScreen(router: router)
        window?.rootViewController = UINavigationController(rootViewController: leaguesScreen)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
    }

}

