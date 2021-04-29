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
//    private var parentView: UIView!
    private let image: UIImage! = UIImage(systemName: "minus")
    private var numberOfQuestions: Int
    private var answers: [QuestionStatus]
    private var trackerViews: [UIImageView]
    private var aboveView: UIView!
    
    private let gap: CGFloat = 10
    private let height: CGFloat = 5
    
    init(numberOfQuestions: Int, parentView: UIView, aboveView: UIView) {
        self.numberOfQuestions = numberOfQuestions
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
    
    func buildViews() {
        for _ in 0...(numberOfQuestions - 1) {
//            let image2 = image.withTintColor(QuestionStatus.unanswered.color)
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
//        autoAlignAxis(toSuperviewAxis: .horizontal)
        for (index, view) in trackerViews.enumerated() {
            print(index)
            view.autoSetDimension(.height, toSize: height)
            if(index == 0) {
                view.autoPinEdge(toSuperviewEdge: .leading)
//                view.autoMatch(.width, to: .width, of: <#T##UIView#>, withOffset: <#T##CGFloat#>)
//                view.autoPinEdge(.trailing, to: .leading, of: trackerViews[1], withOffset: gap)
            } else if (index == numberOfQuestions - 1) {
                view.autoMatch(.width, to: .width, of: trackerViews[0])
                view.autoPinEdge(toSuperviewEdge: .trailing)
                view.autoPinEdge(.leading, to: .trailing, of: trackerViews[index - 1], withOffset: gap)
            } else {
                view.autoMatch(.width, to: .width, of: trackerViews[0])
                view.autoPinEdge(.leading, to: .trailing, of: trackerViews[index - 1], withOffset: gap)
//                view.autoPinEdge(.trailing, to: .leading, of: trackerViews[index + 1], withOffset: gap)
            }
        }
    }
    
    private func refreshView() {
        for (index, answerStatus) in answers.enumerated() {
//            let image2 = image.withTintColor(answerStatus.color)
            let view = trackerViews[index]
            view.tintColor = answerStatus.color
//            trackerViews[index] = UIImageView(image: image2)
//            trackerViews[index] = view
        }
        
    }
    
    func setAnswer(atIndex idx: Int, to status: QuestionStatus) {
        self.answers[idx] = status
        refreshView()
    }
}
