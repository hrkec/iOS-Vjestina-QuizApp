//
//  QuestionTrackerView.swift
//  QuizApp
//
//  Created by Marin on 20.04.2021..
//

import Foundation
import UIKit

enum QuestionStatus {
    case unanswered
    case correct
    case incorrect
}

class QuestionTrackerView: UIView {
    private var numberOfQuestions: Int
    private var answers: [QuestionStatus]
    
    init(numberOfQuestions: Int) {
        self.numberOfQuestions = numberOfQuestions
        self.answers = [QuestionStatus]()
        for _ in 0...numberOfQuestions {
            self.answers.append(.unanswered)
        }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
