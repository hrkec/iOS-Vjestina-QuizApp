//
//  Quiz+CD.swift
//  QuizApp
//
//  Created by Marin on 28.05.2021..
//

import CoreData
import UIKit

extension Quiz {
    init(with entity: QuizCD, and questionsCD: [Question]) {
        id = Int(entity.identifier)
        title = entity.title
        description = entity.quizDescription
        category = QuizCategory(rawValue: entity.category)!
        level = Int(entity.level)
        imageUrl = entity.imageURL
        questions = questionsCD
    }
    
}
