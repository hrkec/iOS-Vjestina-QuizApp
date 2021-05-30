//
//  QuizDataRepository.swift
//  QuizApp
//
//  Created by Marin on 24.05.2021..
//

class QuizDataRepository: QuizRepositoryProtocol {
    private let networkDataSource: QuizNetworkSourceProtocol
    private let coreDataSource: QuizCoreDataSourceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.coreDataSource = QuizCoreDataSource()
        self.networkDataSource = QuizNetworkDataSource(networkService: networkService, quizCoreDataSource: coreDataSource)
    }
    
    func fetchData(filter: FilterSettings) -> [Quiz] {
        var quizzes: [Quiz] = []
        
        // if network is connected, fetch quizzes from network (and save in core data)
        if(NetworkMonitor.shared.isConnected){
            networkDataSource.fetchQuizzesFromNetwork()
        }
        quizzes = coreDataSource.fetchQuizzesFromCoreData(filter: filter)
        
        return quizzes
    }
    
    func fetchRemoteData() {
        networkDataSource.fetchQuizzesFromNetwork()
    }
    
    func fetchLocalData(filter: FilterSettings) -> [Quiz] {
        return coreDataSource.fetchQuizzesFromCoreData(filter: filter)
    }
    
    func deleteLocalData(withId id: Int) {
        coreDataSource.deleteQuiz(withId: id)
    }
}
