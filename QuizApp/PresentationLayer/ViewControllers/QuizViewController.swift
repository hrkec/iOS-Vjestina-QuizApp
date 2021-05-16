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
    private var answerButtons: [UIButton]!
    
    private let myFontBold = UIFont(name: "ArialRoundedMTBold", size: 20)
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var router: AppRouterProtocol!
    private var networkService: NetworkServiceProtocol!
    
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
    
    private var startTime: DispatchTime!
    private var endTime: DispatchTime!
    
    convenience init(router: AppRouterProtocol, networkService: NetworkServiceProtocol, quiz: Quiz) {
        self.init()
        
        self.router = router
        self.networkService = networkService
        self.quiz = quiz
        self.quizQuestions = quiz.questions
        self.totalNumberOfQuestions = quiz.questions.count
        self.answerButtons = []
        self.startTime = DispatchTime.now()
        self.endTime = DispatchTime.now()
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
        router.leaveQuiz()
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView()
        view.addSubview(gradientView)
        
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
    
        for i in 0...(quiz.questions[0].answers.count - 1) {
            let button = UIButton()
            view.addSubview(button)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = myFont
            button.layer.backgroundColor = buttonBackgroundColor
            button.layer.cornerRadius = cornerRadius
            button.tag = i
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            answerButtons.append(button)
        }
        reloadData()
    }
    
    @objc final func buttonAction(sender: UIButton!) {
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
            let correctButton: UIButton! = answerButtons[correctAnswer]
            
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
            
            for i in 0...(answerButtons.count - 1) {
                let button = answerButtons[i]
                button.setTitle(answers[i], for: .normal)
            }
        } else {
            // Ending a quiz, calculating time
            self.endTime = DispatchTime.now()
            let nanoTime = endTime.uptimeNanoseconds - self.startTime.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            router.showQuizResultScreen(correct: numberOfCorrectAnswers, outOf: totalNumberOfQuestions)
            networkService.sendQuizResult(quizId: quiz.id, noOfCorrect: numberOfCorrectAnswers, time: timeInterval) {
                result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(_):
                        print("Quiz sending failure")
                        break
                    case .success(_):
                        break
                    }
                }
            }
        }
    }
    
    // Function for adding constraints for all views
    private func addConstraints() {
        gradientView.addConstraints()
        
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        
        questionLabel.autoPinEdge(.top, to: .bottom, of: questionTrackerView, withOffset: 10)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        
        for i in 0...(answerButtons.count - 1) {
            let button = answerButtons[i]
            if(i == 0) {
                button.autoPinEdge(.top, to: .bottom, of: questionLabel, withOffset: 15)
            }
            else {
                button.autoPinEdge(.top, to: .bottom, of: answerButtons[i - 1], withOffset: 10)
            }
            button.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
            button.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
            button.autoSetDimension(.height, toSize: buttonHeight)
        }
    }
}
