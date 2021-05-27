//
//  QuizCoreDataSourceProtocol.swift
//  QuizApp
//
//  Created by Marin on 24.05.2021..
//

protocol QuizCoreDataSourceProtocol {
    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz]
    func saveNewQuizzes(_ quizzes: [Quiz])
    func deleteQuiz(withId id: Int)
}
