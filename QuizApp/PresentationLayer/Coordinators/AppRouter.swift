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
    private var quizDataRepository: QuizRepositoryProtocol!
    private var window: UIWindow!
    
    private var quizImage: UIImage! = UIImage(systemName: "stopwatch")
    private var quizSelectedImage: UIImage! = UIImage(systemName: "stopwatch.fill")
    
    private var settingsImage: UIImage! = UIImage(systemName: "gearshape")
    private var settingsSelectedImage: UIImage! = UIImage(systemName: "gearshape.fill")
    
    private var searchImage: UIImage! = UIImage(systemName: "magnifyingglass.circle")
    private var searchSelectedImage: UIImage! = UIImage(systemName: "magnifyingglass.circle.fill")

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkService = NetworkService()
        self.quizDataRepository = QuizDataRepository(networkService: self.networkService)
        setTranslucentNavBar()
    }
    
    func setStartScreen(in window: UIWindow?) {
        self.window = window
        let vc = LoginViewController(router: self, networkService: self.networkService)
//        let vc = SearchQuizViewController(router: self, quizDataRepository: quizDataRepository)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func showQuizzesScreen() {
        let vc = QuizzesViewController(router: self, networkService: self.networkService, quizDataRepository: self.quizDataRepository)
        vc.tabBarItem = UITabBarItem(title: "Quiz", image: quizImage, selectedImage: quizSelectedImage)
        
        let svc = SettingsViewController(router: self)
        svc.tabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: settingsSelectedImage)
        
        let sqv = SearchQuizViewController(router: self, quizDataRepository: quizDataRepository)
        sqv.tabBarItem = UITabBarItem(title: "Search", image: searchImage, selectedImage: searchSelectedImage)
        
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .red
        tabBarController.viewControllers = [vc, sqv, svc]
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
