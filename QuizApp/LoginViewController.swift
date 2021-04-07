//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Marin on 04.04.2021..
//

import Foundation
import UIKit
import PureLayout

class LoginViewController: UIViewController {
    private var titleLabel: UILabel!
    private var gradientView: UIView!
    private var emailField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    private var toggleButton: UIButton!
    
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
        titleLabel = UILabel()
        titleLabel.text = "QuizApp"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .red
        
        // Building a textfield for email input
        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.layer.cornerRadius = cornerRadius
        emailField.layer.borderWidth = 1.0
//        emailField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        emailField.layer.sublayerTransform = CATransform3DMakeScale(0.9, 1, 1)
        
        // Building a textfield for password input
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.layer.cornerRadius = cornerRadius
        passwordField.layer.borderWidth = 1.0
//        passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
//        passwordField.layer.sublayerTransform = CATransform3DMakeScale(0.9, 1, 1)
        
        // Building a toggle button for password visibility in password textfield
        toggleButton = UIButton()
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .black
        toggleButton.addAction(.init{
            _ in self.passwordField.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
        
        // Building a button for logging in
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        loginButton.layer.cornerRadius = cornerRadius
        loginButton.layer.borderWidth = 1.0
        // Adding login action after button is touched
        loginButton.addAction(.init {
            _ in
            let status: LoginStatus = DataService().login(email: self.emailField.text!, password: self.passwordField.text!)
            print(status)
        }, for: .touchUpInside)
        
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(toggleButton)
    }
    
    private func addConstraints() {
        // TODO: FIX CONSTRAINTS
        gradientView.autoPinEdgesToSuperviewEdges()
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 60)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
//        passwordField.autoCenterInSuperview()
//        passwordField.autoPinEdge(toSuperviewEdge: .top, withInset: view.bounds.height / 3)
//        passwordField.autoPinEdge(.top, to: .top, of:)
        
        emailField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: offset)
        emailField.autoPinEdge(.bottom, to: .top, of: passwordField, withOffset: -offset)
        emailField.autoAlignAxis(toSuperviewAxis: .vertical)
        emailField.autoSetDimension(.width, toSize: buttonWidth)
        emailField.autoSetDimension(.height, toSize: buttonHeight)
        
        passwordField.autoPinEdge(.top, to: .bottom, of: emailField, withOffset: offset)
        passwordField.autoAlignAxis(toSuperviewAxis: .vertical)
        passwordField.autoSetDimension(.width, toSize: buttonWidth)
        passwordField.autoSetDimension(.height, toSize: buttonHeight)
        
        toggleButton.autoAlignAxis(.horizontal, toSameAxisOf: passwordField)
        toggleButton.autoPinEdge(.trailing, to: .trailing, of: passwordField)
        toggleButton.autoSetDimension(.width, toSize: buttonHeight)
        
        loginButton.autoPinEdge(.top, to: .bottom, of: passwordField, withOffset: offset)
        loginButton.autoAlignAxis(toSuperviewAxis: .vertical)
        loginButton.autoSetDimension(.width, toSize: buttonWidth)
        loginButton.autoSetDimension(.height, toSize: buttonHeight)
    }
}

class GradientView: UIView {
    private let gradient: CAGradientLayer = CAGradientLayer()
    private let gradientStartColor: UIColor
    private let gradientEndColor: UIColor
    
    init(gradientStartColor: UIColor, gradientEndColor: UIColor){
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: layer)
            gradient.frame = self.bounds
        }

        override public func draw(_ rect: CGRect) {
            gradient.frame = self.bounds
            gradient.colors = [gradientEndColor.cgColor, gradientStartColor.cgColor]
//            gradient.startPoint = CGPoint(x: 1, y: 0)
//            gradient.endPoint = CGPoint(x: 0.2, y: 1)
            gradient.startPoint = .zero
            gradient.endPoint = CGPoint(x: 1, y: 1)
            if gradient.superlayer == nil {
                layer.insertSublayer(gradient, at: 0)
            }
        }
}
