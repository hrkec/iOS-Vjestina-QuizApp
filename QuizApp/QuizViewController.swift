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
    private var questionNumberLabel: UILabel!
    private var questionTrackerView: QuestionTrackerView!
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
    private let buttonHeight: CGFloat = 40
    private let buttonBackgroundColor: CGColor = CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    private let correctAnswerButtonColor: CGColor = CGColor(red: 0.04, green: 0.94, blue: 0.28, alpha: 1.00)
    private let incorrectAnswerButtonColor: CGColor = CGColor(red: 0.93, green: 0.22, blue: 0.22, alpha: 1.00)
    private let animationDuration = 1.5
    
    convenience init(router: AppRouterProtocol, quiz: Quiz) {
        self.init()
        
        self.router = router
        self.quiz = quiz
        self.quizQuestions = quiz.questions
        self.totalNumberOfQuestions = quiz.questions.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
        
        navigationItem.title = "QuizApp"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: myFontBold!, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(handleReturnButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    // Function for handling return (back) button
    @objc func handleReturnButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView(superView: view)
        
        questionNumberLabel = UILabel()
        view.addSubview(questionNumberLabel)
        questionNumberLabel.font = myFont
        questionNumberLabel.textColor = .white
        
        questionTrackerView = QuestionTrackerView(numberOfQuestions: totalNumberOfQuestions, parentView: view, aboveView: questionNumberLabel)
        
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
        if(numberOfAnsweredQuestions == totalNumberOfQuestions) {
            numberOfAnsweredQuestions -= 1
        }
        
        let currentQuestion: Question = quiz.questions[numberOfAnsweredQuestions]
        let correctAnswer = currentQuestion.correctAnswer
        
        // If user chose correct answer
        if (correctAnswer == sender.tag) {
            numberOfCorrectAnswers += 1
            
            // Set Question Tracker View to correct
            questionTrackerView.setAnswer(atIndex: numberOfAnsweredQuestions, to: .correct)
            
            // Animate the change of correct button color to green
            UIView.transition(with: sender, duration: animationDuration, options: .curveEaseIn, animations: {
                sender.layer.backgroundColor = self.correctAnswerButtonColor
            })

            // Change the correct button color back to default color
            UIView.transition(with: sender, duration: animationDuration, options: .curveEaseIn, animations: {
                sender.layer.backgroundColor = self.buttonBackgroundColor
            })
        } else { // If user chose incorrect answer
            questionTrackerView.setAnswer(atIndex: numberOfAnsweredQuestions, to: .incorrect)
            // Animate the change of chosen (incorrect) answer button color to red (incorrect color)
            UIView.transition(with: sender, duration: animationDuration, options: .curveEaseIn, animations: {
                sender.layer.backgroundColor = self.incorrectAnswerButtonColor
            })
            // Change the chosen (incorrect) button color back to default color
            UIView.transition(with: sender, duration: animationDuration, options: .curveEaseIn, animations: {
                sender.layer.backgroundColor = self.buttonBackgroundColor
            })
            
            // Determine which button is correct
            var correctButton: UIButton!
            switch(correctAnswer) {
            case 0:
                correctButton = answer0Button
                break
            case 1:
                correctButton = answer1Button
                break
            case 2:
                correctButton = answer2Button
                break
            default:
                correctButton = answer3Button
                break
            }
            
            // Animate the change of correct button color to green
            UIView.transition(with: correctButton, duration: animationDuration, options: .curveEaseIn, animations: {
                correctButton.layer.backgroundColor = self.correctAnswerButtonColor
            })
            // Change the correct button color back to default color
            UIView.transition(with: correctButton, duration: animationDuration, options: .curveEaseIn, animations: {
                correctButton.layer.backgroundColor = self.buttonBackgroundColor
            })
        }
        
        numberOfAnsweredQuestions += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, qos: .userInitiated) {
            self.reloadData()
        }
        
    }

    // Function for reloading data
    // It loads next question after button press (answering on previous question)
    private func reloadData() {
        if(numberOfAnsweredQuestions != totalNumberOfQuestions) {
            questionNumberLabel.text = "\(numberOfAnsweredQuestions + 1)/\(String(totalNumberOfQuestions))"
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
    
    // Function for adding constraints for all views
    private func addConstraints() {
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        
        questionLabel.autoPinEdge(.top, to: .bottom, of: questionTrackerView, withOffset: 10)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        
        answer0Button.autoPinEdge(.top, to: .bottom, of: questionLabel, withOffset: 15)
        answer0Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer0Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        answer0Button.autoSetDimension(.height, toSize: buttonHeight)
        
        answer1Button.autoPinEdge(.top, to: .bottom, of: answer0Button, withOffset: 10)
        answer1Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer1Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        answer1Button.autoSetDimension(.height, toSize: buttonHeight)
        
        answer2Button.autoPinEdge(.top, to: .bottom, of: answer1Button, withOffset: 10)
        answer2Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer2Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        answer2Button.autoSetDimension(.height, toSize: buttonHeight)
        
        answer3Button.autoPinEdge(.top, to: .bottom, of: answer2Button, withOffset: 10)
        answer3Button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        answer3Button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        answer3Button.autoSetDimension(.height, toSize: buttonHeight)

    }
}
