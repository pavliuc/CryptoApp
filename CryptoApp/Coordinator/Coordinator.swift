//
//  Coordinator.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 21.08.2022.
//

import Foundation
import UIKit

class AppCoordinator {
    
    // MARK: - Properties

    private let navigationController = UINavigationController()
    
    // MARK: - Accessors
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    // MARK: - Internal functions
    
    func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        showMainViewController()
    }
    
    // MARK: - Private functions
    
    private func showMainViewController() {
        let mainViewController = MainViewController()
        navigationController.pushViewController(mainViewController, animated: true)
    }
}
