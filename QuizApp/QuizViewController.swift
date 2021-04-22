//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Marin on 19.04.2021..
//

import Foundation
import UIKit
import PureLayout

class QuizViewController: UIViewController {
    private var gradientView: GradientView!
    private var questionLabel: UILabel!
    private var answer0Button: UIButton!
    private var answer1Button: UIButton!
    private var answer2Button: UIButton!
    private var answer3Button: UIButton!
    
    private let myFontBold = UIFont(name: "ArialRoundedMTBold", size: 20)
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var router: AppRouterProtocol!
    
    private var quiz: Quiz!
    private var quizQuestions: [Question]!
    
    private var numberOfAnsweredQuestions: Int = 0
    private var numberOfCorrectAnswers: Int = 0
    private var totalNumberOfQuestions: Int!
    private let cornerRadius: CGFloat = 20
//    private let buttonWidth: CGFloat = 300
    private let buttonHeight: CGFloat = 40
    private let buttonBackgroundColor: CGColor = CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    
    convenience init(router: AppRouterProtocol, quiz: Quiz) {
        self.init()
        
        self.router = router
        self.quiz = quiz
        self.quizQuestions = quiz.questions
        self.totalNumberOfQuestions = quiz.questions.count
//        print(quiz.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
        
        navigationItem.title = "QuizApp"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: myFontBold!, NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleReturnButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func handleReturnButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView(superView: view)
        
        questionLabel = UILabel()
        view.addSubview(questionLabel)
        questionLabel.font = myFontBold
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        
        answer0Button = UIButton()
        view.addSubview(answer0Button)
        answer0Button.setTitleColor(.white, for: .normal)
        answer0Button.titleLabel?.font = myFont
        answer0Button.layer.backgroundColor = buttonBackgroundColor
        answer0Button.layer.cornerRadius = cornerRadius
        answer0Button.tag = 0
        answer0Button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        answer1Button = UIButton()
        view.addSubview(answer1Button)
        answer1Button.setTitleColor(.white, for: .normal)
        answer1Button.titleLabel?.font = myFont
        answer1Button.layer.backgroundColor = buttonBackgroundColor
        answer1Button.layer.cornerRadius = cornerRadius
        answer1Button.tag = 1
        answer1Button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        answer2Button = UIButton()
        view.addSubview(answer2Button)
        answer2Button.setTitleColor(.white, for: .normal)
        answer2Button.titleLabel?.font = myFont
        answer2Button.layer.backgroundColor = buttonBackgroundColor
        answer2Button.layer.cornerRadius = cornerRadius
        answer2Button.tag = 2
        answer2Button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        answer3Button = UIButton()
        view.addSubview(answer3Button)
        answer3Button.setTitleColor(.white, for: .normal)
        answer3Button.titleLabel?.font = myFont
        answer3Button.layer.backgroundColor = buttonBackgroundColor
        answer3Button.layer.cornerRadius = cornerRadius
        answer3Button.tag = 3
        answer3Button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        reloadData()
    }
    
    @objc final func buttonAction(sender: UIButton!) {
//        print("Trenutno pitanje je broj \(self.numberOfAnsweredQuestions) od \(self.totalNumberOfQuestions) i pritisnut je gumb \(sender.tag)")
//        print("Tocan odgovor je na broju \(self.quiz.questions[self.numberOfAnsweredQuestions].correctAnswer)")
        
        if(numberOfAnsweredQuestions == totalNumberOfQuestions) {
            numberOfAnsweredQuestions -= 1
        }
        
        let currentQuestion: Question = quiz.questions[numberOfAnsweredQuestions]
        let correctAnswer = currentQuestion.correctAnswer
        if (correctAnswer == sender.tag) {
            numberOfCorrectAnswers += 1
        }
        print(numberOfCorrectAnswers)
        
        // TODO: Prikazati je li tocno ili netocno odgovoreno...
        
        numberOfAnsweredQuestions += 1
        reloadData()
        
    }

    private func reloadData() {
        if(numberOfAnsweredQuestions != totalNumberOfQuestions) {
            let question: Question = quiz.questions[numberOfAnsweredQuestions]
            questionLabel.text = question.question
            
            let answers: [String] = question.answers
            
            answer0Button.setTitle(answers[0], for: .normal)
            answer1Button.setTitle(answers[1], for: .normal)
            answer2Button.setTitle(answers[2], for: .normal)
            answer3Button.setTitle(answers[3], for: .normal)
        } else {
            router.showQuizResultScreen(correct: numberOfCorrectAnswers, outOf: totalNumberOfQuestions)
        }
    }
    
    private func addConstraints() {
        questionLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        
        answer0Button.autoPinEdge(.top, to: .bottom, of: questionLabel, withOffset: 15)
        answer0Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer0Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
//        answer0Button.autoSetDimension(.width, toSize: buttonWidth)
        answer0Button.autoSetDimension(.height, toSize: buttonHeight)
        
        answer1Button.autoPinEdge(.top, to: .bottom, of: answer0Button, withOffset: 10)
        answer1Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer1Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
//        answer1Button.autoSetDimension(.width, toSize: buttonWidth)
        answer1Button.autoSetDimension(.height, toSize: buttonHeight)
        
        answer2Button.autoPinEdge(.top, to: .bottom, of: answer1Button, withOffset: 10)
        answer2Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer2Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
//        answer2Button.autoSetDimension(.width, toSize: buttonWidth)
        answer2Button.autoSetDimension(.height, toSize: buttonHeight)
        
        answer3Button.autoPinEdge(.top, to: .bottom, of: answer2Button, withOffset: 10)
        answer3Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer3Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
//        answer3Button.autoSetDimension(.width, toSize: buttonWidth)
        answer3Button.autoSetDimension(.height, toSize: buttonHeight)

    }
}
