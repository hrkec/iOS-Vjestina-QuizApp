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
//    private var titleLabel: UILabel!
    private var titleLabel: TitleLabel!
    private var gradientView: GradientView!
    private var emailField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    private var toggleButton: UIButton!
    private var errorLabel: UILabel!
    
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
        
        // Building a textfield for email input
        emailField = UITextFieldWithPadding()
        emailField.placeholder = "Email"
        emailField.layer.cornerRadius = cornerRadius
        emailField.layer.borderWidth = 1.0
        
        // Building a textfield for password input
        passwordField = UITextFieldWithPadding()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.layer.cornerRadius = cornerRadius
//        passwordField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        passwordField.layer.borderWidth = 1.0
        
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
        loginButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        loginButton.layer.cornerRadius = cornerRadius
        loginButton.layer.borderWidth = 1.0
        // Adding login action after button is touched and showing error label if there is an error
        errorLabel = UILabel(); errorLabel.isHidden = true; errorLabel.textAlignment = .center
        errorLabel.text = "Wrong email or password"
        loginButton.addAction(.init {
            _ in
            self.errorLabel.isHidden = true
            let status: LoginStatus = DataService().login(email: self.emailField.text!, password: self.passwordField.text!)
            print(status)
            switch(status){
                case .success:
                    break
                case .error( _, _):
                    self.errorLabel.isHidden = false
            }
        }, for: .touchUpInside)
        
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(toggleButton)
        view.addSubview(errorLabel)
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        titleLabel.addConstraints()
        
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
        
        errorLabel.autoPinEdge(.top, to: .bottom, of: loginButton, withOffset: offset)
        errorLabel.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}

class UITextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
}
