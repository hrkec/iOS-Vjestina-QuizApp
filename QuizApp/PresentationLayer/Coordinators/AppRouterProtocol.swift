//
//  AppRouterProtocol.swift
//  QuizApp
//
//  Created by Marin on 16.05.2021..
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showQuizzesScreen()
    func showSelectedQuizScreen(quiz: Quiz)
    func leaveQuiz()
    func showQuizResultScreen(correct: Int, outOf total: Int)
    func returnToStartScreen()
    func logout()
}
