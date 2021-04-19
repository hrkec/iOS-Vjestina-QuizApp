//
//  AppRouter.swift
//  QuizApp
//
//  Created by Marin on 18.04.2021..
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showQuizzesScreen()
}

class AppRouter: AppRouterProtocol {
    private var navigationController: UINavigationController!
    private var window: UIWindow!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
        self.window = window
        let vc = LoginViewController(router: self)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func showQuizzesScreen() {
        let vc = QuizzesViewController(router: self)
        navigationController.pushViewController(vc, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
