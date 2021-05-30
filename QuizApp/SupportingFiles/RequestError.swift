//
//  RequestError.swift
//  QuizApp
//
//  Created by Marin on 29.05.2021..
//

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
    case urlError
}
