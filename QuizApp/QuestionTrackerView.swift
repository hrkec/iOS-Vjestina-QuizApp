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
    
    var color: UIColor {
        switch self {
        case .unanswered:
            return .gray
        case .correct:
            return .green
        case .incorrect:
            return .red
        }
    }
}

class QuestionTrackerView: UIView {
    private let image: UIImage! = UIImage(systemName: "minus")
    private var numberOfQuestions: Int
    private var answers: [QuestionStatus]
    private var trackerViews: [UIImageView]
    private var aboveView: UIView!
    
    private let gap: CGFloat = 10
    private let height: CGFloat = 5
    
    init(numberOfQuestions: Int, parentView: UIView, aboveView: UIView) {
        self.numberOfQuestions = numberOfQuestions
        
        // Initialize array of question status as unanswered
        self.answers = [QuestionStatus]()
        for _ in 0...(numberOfQuestions - 1) {
            self.answers.append(.unanswered)
        }
        
        self.trackerViews = [UIImageView]()
        super.init(frame: .zero)
        
        self.aboveView = aboveView
        parentView.addSubview(self)
        buildViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        for _ in 0...(numberOfQuestions - 1) {
            let view = UIImageView(image: image)
            view.tintColor = QuestionStatus.unanswered.color
            addSubview(view)
            trackerViews.append(view)
        }
    }
    
    private func addConstraints() {
        autoSetDimension(.height, toSize: height)
        autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        autoPinEdge(.top, to: .bottom, of: aboveView, withOffset: 10)
        
        // Set contraints for each question view
        // -- Set equal width to every view
        // -- Set equal offset (gap) between every view
        for (index, view) in trackerViews.enumerated() {
            view.autoSetDimension(.height, toSize: height)
            if(index == 0) {
                view.autoPinEdge(toSuperviewEdge: .leading)
            } else if (index == numberOfQuestions - 1) {
                view.autoMatch(.width, to: .width, of: trackerViews[0])
                view.autoPinEdge(toSuperviewEdge: .trailing)
                view.autoPinEdge(.leading, to: .trailing, of: trackerViews[index - 1], withOffset: gap)
            } else {
                view.autoMatch(.width, to: .width, of: trackerViews[0])
                view.autoPinEdge(.leading, to: .trailing, of: trackerViews[index - 1], withOffset: gap)
            }
        }
    }
    
    // Function for refreshing whole question tracker view after chaning a question status
    private func refreshView() {
        for (index, answerStatus) in answers.enumerated() {
            let view = trackerViews[index]
            view.tintColor = answerStatus.color
        }
    }
    
    // Set answer at index idx to QuestionStatus status
    func setAnswer(atIndex idx: Int, to status: QuestionStatus) {
        self.answers[idx] = status
        refreshView()
    }
}
