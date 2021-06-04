//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Marin on 22.04.2021..
//

import UIKit

class QuizResultViewController: UIViewController {
    private var gradientView: GradientView!
    private var titleLabel: TitleLabel!
    private var resultsLabel: UILabel!
    private var finishQuizButton: UIButton!
    
    private let myFontBold = UIFont(name: "ArialRoundedMTBold", size: 100)
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    private let buttonBackgroundColor: CGColor = CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    private let cornerRadius: CGFloat = 20
    private let buttonWidth: CGFloat = 300
    private let buttonHeight: CGFloat = 40
    
    private var router: AppRouterProtocol!
    private var correctAnswers: Int!
    private var totalAnswers: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()

        // Disabling the return to previous view
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    convenience init(router: AppRouterProtocol, correct: Int, outOf total: Int) {
        self.init()
        
        self.router = router
        self.correctAnswers = correct
        self.totalAnswers = total
    }
    
    private func buildViews() {
        gradientView = GradientView()
        view.addSubview(gradientView)
        
        titleLabel = TitleLabel()
        view.addSubview(titleLabel)
        
        // Label for showing quiz results
        resultsLabel = UILabel()
        view.addSubview(resultsLabel)
        resultsLabel.font = myFontBold
        resultsLabel.textColor = .white
        resultsLabel.numberOfLines = 0
        resultsLabel.lineBreakMode = .byWordWrapping
        resultsLabel.text = "\(String(correctAnswers))/\(String(totalAnswers))"
        
        // Button for ending quiz - return to start screen
        finishQuizButton = UIButton()
        view.addSubview(finishQuizButton)
        finishQuizButton.setTitle("Finish Quiz", for: .normal)
        finishQuizButton.setTitleColor(.white, for: .normal)
        finishQuizButton.titleLabel?.font = myFont
        finishQuizButton.layer.backgroundColor = buttonBackgroundColor
        finishQuizButton.layer.cornerRadius = cornerRadius
        finishQuizButton.addTarget(self, action: #selector(finishQuizAction), for: .touchUpInside)
        
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        titleLabel.addConstraints()
        
        resultsLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        resultsLabel.autoCenterInSuperview()
        
        finishQuizButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        finishQuizButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        finishQuizButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        finishQuizButton.autoSetDimension(.height, toSize: buttonHeight)
    }

    // Function for handling the press of the finish quiz button
    // -- returns to the start screen
    @objc final func finishQuizAction(sender: UIButton!) {
        router.returnToStartScreen()
    }
}
