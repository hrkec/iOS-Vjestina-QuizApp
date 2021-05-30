//
//  NetworkServiceProtocol.swift
//  QuizApp
//
//  Created by Marin on 10.05.2021..
//

import UIKit

protocol NetworkServiceProtocol {
    func login(username:String, password:String, completionHandler: @escaping(Result<LoginData, RequestError>) -> Void) -> Void
    
    func fetchQuizzes(completionHandler: @escaping(Result<[Quiz], RequestError>) -> Void)
    
    func sendQuizResult(quizId: Int, noOfCorrect: Int, time: Double,
                        completionHandler: @escaping(Result<String, RequestError>) -> Void)
}
