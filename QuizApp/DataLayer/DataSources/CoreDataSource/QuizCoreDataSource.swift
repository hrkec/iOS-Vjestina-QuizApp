//
//  QuizCoreDataSource.swift
//  QuizApp
//
//  Created by Marin on 24.05.2021..
//

import CoreData

struct QuizCoreDataSource: QuizCoreDataSourceProtocol{
    
    private let coreDataStack: CoreDataStack
    
    init() {
        self.coreDataStack = CoreDataStack(modelName: "Model")
    }
    
    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz] {
        let request: NSFetchRequest<QuizCD> = QuizCD.fetchRequest()
        var namePredicate = NSPredicate(value: true)
        var descriptionPredicate = NSPredicate(value:true)
        
        if let text = filter.searchText, !text.isEmpty {
            namePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(QuizCD.title), text)
            descriptionPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(QuizCD.quizDescription), text)
        }
        
        do {
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, descriptionPredicate])
            request.predicate = predicate
            let results = try coreDataStack.managedContext.fetch(request)
            return convertToQuizzes(quizzesCD: results)
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
        
    }
    
    func updateQuizzes(_ quizzes: [Quiz]) {
        for quiz in quizzes {
            let request: NSFetchRequest<QuizCD> = QuizCD.fetchRequest()
            let predicate = NSPredicate(format: "%K=%@", #keyPath(QuizCD.identifier), "\(quiz.id)")
            request.predicate = predicate
            
            do {
                let fetchedQuizzes: [QuizCD] = try coreDataStack.managedContext.fetch(request)
                if fetchedQuizzes.count == 0 {
                    saveQuiz(quiz)
                } else {
                    updateQuiz(quizCD: fetchedQuizzes[0], quiz: quiz)
                }
            } catch (let error) {
                fatalError("Error when updating quizzes: \(error)")
            }
        }
    }
    
    func deleteQuiz(withId id: Int) {
        guard let quiz = try? fetchQuiz(withId: id) else { return }

        coreDataStack.managedContext.delete(quiz)

        do {
            try coreDataStack.managedContext.save()
        } catch {
            print("Error when saving after deletion of quiz: \(error)")
        }
    }
    
    private func saveQuiz(_ quiz: Quiz) {
        let entity = NSEntityDescription.entity(forEntityName: "QuizCD", in: coreDataStack.managedContext)!
        let quizCD = QuizCD(entity: entity, insertInto: coreDataStack.managedContext)
        quizCD.identifier = Int64(quiz.id)
        quizCD.title = quiz.title
        quizCD.category = quiz.category.rawValue
        quizCD.imageURL = quiz.imageUrl
        quizCD.level = Int16(quiz.level)
        quizCD.quizDescription = quiz.description
        for question in quiz.questions {
            quizCD.addToQuestions(createQuestionCD(from: question, context: coreDataStack.managedContext))
        }
        try? coreDataStack.managedContext.save()
    }
    
    private func updateQuiz(quizCD: QuizCD, quiz: Quiz) {
        quizCD.identifier = Int64(quiz.id)
        quizCD.title = quiz.title
        quizCD.category = quiz.category.rawValue
        quizCD.imageURL = quiz.imageUrl
        quizCD.quizDescription = quiz.description
        quizCD.level = Int16(quiz.level)
        quizCD.questions = NSSet()
        for question in quiz.questions {
            let questionCD = updateQuestion(question, context: coreDataStack.managedContext)
            quizCD.addToQuestions(questionCD)
        }
        try? coreDataStack.managedContext.save()
    }
    
    private func updateQuestion(_ question: Question, context: NSManagedObjectContext) -> QuestionCD {
        let request: NSFetchRequest<QuestionCD> = QuestionCD.fetchRequest()
        let predicate = NSPredicate(format: "%K=%@", #keyPath(QuestionCD.identifier), "\(question.id)")
        request.predicate = predicate
        do {
            let fetchedQuestions: [QuestionCD] = try context.fetch(request)
            if fetchedQuestions.count == 0 {
                return createQuestionCD(from: question, context: context)
            } else {
                let questionCD = fetchedQuestions[0]
                questionCD.identifier = Int64(question.id)
                questionCD.question = question.question
                questionCD.answers = question.answers
                questionCD.correctAnswer = Int16(question.correctAnswer)
                return questionCD
            }
        } catch (let error) {
            fatalError("Error when updating: \(error)")
        }
    }
    
    private func fetchQuiz(withId id: Int) throws -> QuizCD? {
        let request: NSFetchRequest<QuizCD> = QuizCD.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(QuizCD.identifier), id)

        let cdResponse = try coreDataStack.managedContext.fetch(request)
        return cdResponse.first
    }
    
    private func createQuestionCD(from question: Question, context: NSManagedObjectContext) -> QuestionCD {
        let entity = NSEntityDescription.entity(forEntityName: "QuestionCD", in: context)!
        let questionCD = QuestionCD(entity: entity, insertInto: context)
        questionCD.identifier = Int64(question.id)
        questionCD.question = question.question
        questionCD.answers = question.answers
        questionCD.correctAnswer = Int16(question.correctAnswer)
        return questionCD
    }
    
    private func convertToQuizzes(quizzesCD: [QuizCD]) -> [Quiz] {
        var quizzes: [Quiz] = []
        
        for quizCD in quizzesCD {
            var questions: [Question] = []
            for question in Array(quizCD.questions) as! [QuestionCD] {
                questions.append(Question(with: question))
            }
            quizzes.append(Quiz(with: quizCD, and: questions))
        }
        
        return quizzes
    }
}
