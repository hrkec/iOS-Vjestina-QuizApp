//
//  NetworkServiceProtocol.swift
//  QuizApp
//
//  Created by Marin on 10.05.2021..
//

import UIKit

// Structure which server returns when logging in
struct LoginData: Codable {
    var token: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}

enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
}

protocol NetworkServiceProtocol {
    func login(username:String, password:String, completionHandler: @escaping(Result<Bool, RequestError>) -> Void) -> Void
    
    func fetchQuizzes(completionHandler: @escaping(Result<[Quiz], RequestError>) -> Void)
    
    func sendQuizResult(quizId: Int, noOfCorrect: Int, time: Double,
                        completionHandler: @escaping(Result<Bool, RequestError>) -> Void)
}
