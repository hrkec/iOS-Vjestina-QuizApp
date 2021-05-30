//
//  QuestionCD+CoreDataProperties.swift
//  
//
//  Created by Five on 30.05.2021..
//
//

import Foundation
import CoreData


extension QuestionCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionCD> {
        return NSFetchRequest<QuestionCD>(entityName: "QuestionCD")
    }

    @NSManaged public var answers: [String]
    @NSManaged public var correctAnswer: Int16
    @NSManaged public var identifier: Int64
    @NSManaged public var question: String
    @NSManaged public var quiz: QuizCD

}
