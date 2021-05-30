//
//  LoginData.swift
//  QuizApp
//
//  Created by Marin on 29.05.2021..
//

// Structure which server returns when logging in
struct LoginData: Codable {
    var token: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}
