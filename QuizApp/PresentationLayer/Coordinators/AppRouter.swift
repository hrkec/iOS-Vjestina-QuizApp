//
//  AppRouter.swift
//  QuizApp
//
//  Created by Marin on 18.04.2021..
//

import Foundation
import UIKit

class AppRouter: AppRouterProtocol {
    private var navigationController: UINavigationController!
    private var networkService: NetworkServiceProtocol!
    private var window: UIWindow!
    
    private var quizImage: UIImage! = UIImage(systemName: "stopwatch")
    private var quizSelectedImage: UIImage! = UIImage(systemName: "stopwatch.fill")
    
    private var settingsImage: UIImage! = UIImage(systemName: "gearshape")
    private var settingsSelectedImage: UIImage! = UIImage(systemName: "gearshape.fill")

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkService = NetworkService()
        setTranslucentNavBar()
    }
    
    func setStartScreen(in window: UIWindow?) {
        self.window = window
        let vc = LoginViewController(router: self, networkService: self.networkService)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func showQuizzesScreen() {
        let vc = QuizzesViewController(router: self, networkService: self.networkService)
        vc.tabBarItem = UITabBarItem(title: "Quiz", image: quizImage, selectedImage: quizSelectedImage)
        
        let svc = SettingsViewController(router: self)
        svc.tabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: settingsSelectedImage)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .red
        tabBarController.viewControllers = [vc, svc]
        navigationController.viewControllers = [tabBarController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showSelectedQuizScreen(quiz: Quiz) {
        let vc = QuizViewController(router: self, networkService: self.networkService, quiz: quiz)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func leaveQuiz() {
        navigationController.popViewController(animated: true)
    }
    
    func showQuizResultScreen(correct: Int, outOf total: Int) {
        let vc = QuizResultViewController(router: self, correct: correct, outOf: total)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func returnToStartScreen() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func logout() {
        returnToStartScreen()
        setStartScreen(in: window)
    }
    
    private func setTranslucentNavBar (){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
}
