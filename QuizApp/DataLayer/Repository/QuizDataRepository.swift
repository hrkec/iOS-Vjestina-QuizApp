//
//  QuizDataRepository.swift
//  QuizApp
//
//  Created by Marin on 24.05.2021..
//

class QuizDataRepository: QuizRepositoryProtocol {
    private let jsonDataSource: QuizJsonSourceProtocol
    private let coreDataSource: QuizCoreDataSourceProtocol
    
    init(jsonDataSource: QuizJsonSourceProtocol, coreDataSource: QuizCoreDataSourceProtocol) {
        self.jsonDataSource = jsonDataSource
        self.coreDataSource = coreDataSource
    }
    
    func fetchRemoteData() throws {
        let quizzes = try jsonDataSource.fetchQuizzesFromJson()
        coreDataSource.saveNewQuizzes(quizzes)
    }
    
    func fetchLocalData(filter: FilterSettings) -> [Quiz] {
        coreDataSource.fetchQuizzesFromCoreData(filter: filter)
    }
    
    func deleteLocalData(withId id: Int) {
        coreDataSource.deleteQuiz(withId: id)
    }
}
