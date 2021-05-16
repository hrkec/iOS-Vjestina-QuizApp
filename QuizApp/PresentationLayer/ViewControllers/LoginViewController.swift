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
    private var titleLabel: TitleLabel!
    private var gradientView: GradientView!
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    private var toggleButton: UIButton!
    private var errorLabel: UILabel!
    private var noInternetView: NoInternetView!
    
    private var buttonWidth: CGFloat = 300
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var router: AppRouterProtocol!
    private var networkService: NetworkServiceProtocol!
    
    convenience init(router: AppRouterProtocol, networkService: NetworkServiceProtocol) {
        self.init()
        
        self.router = router
        self.networkService = networkService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView()
        view.addSubview(gradientView)
        
        // Building a label with the app title
        titleLabel = TitleLabel()
        view.addSubview(titleLabel)
        
        // Building a view to show if there is no internet connection available
        noInternetView = NoInternetView()
        view.addSubview(noInternetView)
        
        let textFieldBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        // Building a textfield for email input
        usernameField = UITextFieldWithPadding()
        usernameField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        usernameField.layer.cornerRadius = cornerRadius
        usernameField.textColor = .white
        usernameField.backgroundColor = textFieldBackgroundColor
        usernameField.font = myFont
        usernameField.addAction(.init {
            _ in self.errorLabel.isHidden = true
        }, for: .allEditingEvents)
        
        // Building a textfield for password input
        passwordField = UITextFieldWithPadding()
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordField.isSecureTextEntry = true
        passwordField.layer.cornerRadius = cornerRadius
        passwordField.textColor = .white
        passwordField.backgroundColor = textFieldBackgroundColor
        passwordField.font = myFont
        passwordField.addAction(.init {
            _ in self.errorLabel.isHidden = true
        }, for: .allEditingEvents)
        
        // Building a toggle button for password visibility in password textfield
        toggleButton = UIButton()
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .white
        toggleButton.addAction(.init{
            _ in self.passwordField.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
        
        // Building a button for logging in
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(gradientView.getGradientEndColor(), for: .normal)
        loginButton.titleLabel?.font = myFont
        loginButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        loginButton.layer.cornerRadius = cornerRadius
        
        // Adding login action after button is touched and showing error label if there is an error
        errorLabel = UILabel(); errorLabel.isHidden = true; errorLabel.textAlignment = .center
        errorLabel.text = "Wrong email or password"
        errorLabel.textColor = .white
        errorLabel.font = myFont
        loginButton.addAction(.init {
            _ in
            self.errorLabel.isHidden = true
            
            print("Is connected? \(NetworkManager.isConnectedToNetwork())")
            
            self.networkService.login(username: self.usernameField.text ?? "", password: self.passwordField.text ?? "") {
                (result: Result<Bool, RequestError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.router.showQuizzesScreen()
                        break
                    
                    case .failure(let error):
                        print(error)
                        self.errorLabel.isHidden = false
                        break
                    }
                }
            }
        }, for: .touchUpInside)
        
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(toggleButton)
        view.addSubview(errorLabel)
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        titleLabel.addConstraints()
        
        usernameField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: offset)
        usernameField.autoPinEdge(.bottom, to: .top, of: passwordField, withOffset: -offset)
        usernameField.autoAlignAxis(toSuperviewAxis: .vertical)
        usernameField.autoSetDimension(.width, toSize: buttonWidth)
        usernameField.autoSetDimension(.height, toSize: buttonHeight)
        
        passwordField.autoPinEdge(.top, to: .bottom, of: usernameField, withOffset: offset)
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
