//
//  QuizCD+CoreDataProperties.swift
//  
//
//  Created by Marin on 27.05.2021..
//
//

import Foundation
import CoreData


extension QuizCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizCD> {
        return NSFetchRequest<QuizCD>(entityName: "QuizCD")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var title: String?
    @NSManaged public var attribute: String?
    @NSManaged public var category: String?
    @NSManaged public var level: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension QuizCD {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuestionCD)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuestionCD)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
