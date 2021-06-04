//
//  Question+CD.swift
//  QuizApp
//
//  Created by Five on 28.05.2021..
//

import CoreData

extension Question {

    init(with entity: QuestionCD) {
        id = Int(entity.identifier)
        question = entity.question
        correctAnswer = Int(entity.correctAnswer)
        answers = entity.answers
    }
}
