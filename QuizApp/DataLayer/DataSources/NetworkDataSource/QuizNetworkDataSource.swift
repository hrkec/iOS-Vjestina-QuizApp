import Foundation

struct QuizNetworkDataSource: QuizNetworkSourceProtocol {
    private let networkService: NetworkServiceProtocol
    private var quizCoreDataSource: QuizCoreDataSourceProtocol
    
    init(networkService: NetworkServiceProtocol, quizCoreDataSource: QuizCoreDataSourceProtocol) {
        self.networkService = networkService
        self.quizCoreDataSource = quizCoreDataSource
    }
    
    func fetchQuizzesFromNetwork(){
        networkService.fetchQuizzes(completionHandler: { response in
            switch response {
            case .failure(_):
                break
            case .success(let quizzes):
                self.quizCoreDataSource.updateQuizzes(quizzes)
            }
        })
    }
    
}
