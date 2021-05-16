//
//  QuizResult.swift
//  QuizApp
//
//  Created by Marin on 13.05.2021..
//

import Foundation

struct QuizResult: Codable {
    var quizId: Int
    var userId: Int
    var time: Double
    var noOfCorrect: Int
    
    enum CodingKeys: String, CodingKey {
        case quizId = "quiz_id"
        case userId = "user_id"
        case time
        case noOfCorrect = "no_of_correct"
    }
}
