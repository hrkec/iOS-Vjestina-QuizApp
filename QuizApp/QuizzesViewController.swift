//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Marin on 07.04.2021..
//

import Foundation
import UIKit

class QuizzesViewController: UIViewController {
    private var titleLabel: TitleLabel!
    private var gradientView: GradientView!
    private var getQuizButton: UIButton!
    
    private var buttonWidth: CGFloat = 250
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView(gradientStartColor: UIColor.white, gradientEndColor: UIColor.gray)
        
        // Building a label with the app title
        titleLabel = TitleLabel()
        
        getQuizButton = UIButton()
        getQuizButton.setTitle("Get Quiz", for: .normal)
        getQuizButton.setTitleColor(.black, for: .normal)
        getQuizButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        getQuizButton.layer.cornerRadius = cornerRadius
        getQuizButton.layer.borderWidth = 1.0
        
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
        view.addSubview(getQuizButton)
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        titleLabel.addConstraints()
        
        getQuizButton.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: offset)
        getQuizButton.autoAlignAxis(toSuperviewAxis: .vertical)
        getQuizButton.autoSetDimension(.width, toSize: buttonWidth)
        getQuizButton.autoSetDimension(.height, toSize: buttonHeight)
        
    }
}
