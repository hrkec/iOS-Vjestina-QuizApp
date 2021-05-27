//
//  QuizCoreDataSource.swift
//  QuizApp
//
//  Created by Marin on 24.05.2021..
//

import CoreData

struct QuizCoreDataSource: QuizCoreDataSourceProtocol{
    
    private let coreDataContext: NSManagedObjectContext
    
    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
    
    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz] {
        let request: NSFetchRequest<QuizCD> = QuizCD.fetchRequest()
        var namePredicate = NSPredicate(value: true)
        
        if let text = filter.searchText, !text.isEmpty {
            namePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(QuizCD.name), text)
        }
        
        // Predicate...
        
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0) }
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
        
    }
    
    func saveNewQuizzes(_ quizzes: [Quiz]) {
        do {
            let newIds = quizzes.map { $0.id }
            try deleteAllQuizzesExcept(withId: newIds)
        }
    }
    
    func deleteQuiz(withId id: Int) {
        guard let quiz = try? fetchQuiz(withId: id) else { return }

        coreDataContext.delete(quiz)

        do {
            try coreDataContext.save()
        } catch {
            print("Error when saving after deletion of quiz: \(error)")
        }
    }
    
    private func fetchQuiz(withId id: Int) throws -> QuizCD? {
        let request: NSFetchRequest<QuizCD> = QuizCD.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(QuizCD.identifier), id)

        let cdResponse = try coreDataContext.fetch(request)
        return cdResponse.first
    }
    
    private func deleteAllQuizzesExcept(withId ids: [Int]) throws {
        let request: NSFetchRequest<QuizCD> = QuizCD.fetchRequest()
        request.predicate = NSPredicate(format: "NOT %K IN %@", #keyPath(QuizCD.identifier), ids)
        
        let quizzesToDelete = try coreDataContext.fetch(request)
        quizzesToDelete.forEach { coreDataContext.delete($0) }
        try coreDataContext.save()
    }
    
}
