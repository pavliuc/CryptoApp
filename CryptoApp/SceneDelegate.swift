//
//  SceneDelegate.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Internal variables
    
    var window: UIWindow?
    
    // MARK: - Private variables
    
    let appCoordinator = AppCoordinator()

    // MARK: - Functions
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        appWindow.windowScene = windowScene
        
        appCoordinator.start()

        appWindow.rootViewController = appCoordinator.rootViewController
        appWindow.makeKeyAndVisible()
        
        window = appWindow
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}


