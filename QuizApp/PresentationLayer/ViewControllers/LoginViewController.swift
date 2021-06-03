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
    private var noConnectionLabel: UILabel!
    
    private var buttonWidth: CGFloat = 300
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    private let animationOption = UIView.AnimationOptions.curveEaseInOut
    private let animationDuration = 1.5
    private let delayStep = 0.25
    
    private var router: AppRouterProtocol!
    private var networkService: NetworkServiceProtocol!
    
    convenience init(router: AppRouterProtocol, networkService: NetworkServiceProtocol) {
        self.init()
        
        self.router = router
        self.networkService = networkService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        usernameField.transform = usernameField.transform.translatedBy(x: -view.frame.width, y: 0)
        passwordField.transform = passwordField.transform.translatedBy(x: -view.frame.width, y: 0)
        toggleButton.transform = toggleButton.transform.translatedBy(x: -view.frame.width, y: 0)
        loginButton.transform = loginButton.transform.translatedBy(x: -view.frame.width, y: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: animationDuration,
                       delay: 0, options: animationOption,
                       animations: {
                        self.usernameField.transform = .identity
                       })
        UIView.animate(withDuration: animationDuration, delay: delayStep, options: animationOption, animations: {
            self.passwordField.transform = .identity
            self.toggleButton.transform = .identity
        })
        UIView.animate(withDuration: animationDuration, delay: 2 * delayStep, options: animationOption, animations: {
            self.loginButton.transform = .identity
        })
        
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
        titleLabel.alpha = 0
        titleLabel.transform = titleLabel.transform.scaledBy(x: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationOption,
                       animations: {
                        self.titleLabel.transform = self.titleLabel.transform.scaledBy(x: 10, y: 10)
                        self.titleLabel.alpha = 1
                       })
        
        noConnectionLabel = UILabel()
        view.addSubview(noConnectionLabel)
        noConnectionLabel.font = myFont
        noConnectionLabel.text = "No Internet connection!"
        noConnectionLabel.textAlignment = .center
        noConnectionLabel.textColor = .white
        noConnectionLabel.isHidden = true
        
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
        usernameField.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOption, animations: {
            self.usernameField.alpha = 1
        })
        
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
        passwordField.alpha = 0
        
        // Building a toggle button for password visibility in password textfield
        toggleButton = UIButton()
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .white
        toggleButton.addAction(.init{
            _ in self.passwordField.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
        toggleButton.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: delayStep, options: animationOption, animations: {
            self.passwordField.alpha = 1
            self.toggleButton.alpha = 1
        })
        
        // Building a button for logging in
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(gradientView.getGradientEndColor(), for: .normal)
        loginButton.titleLabel?.font = myFont
        loginButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        loginButton.layer.cornerRadius = cornerRadius
        loginButton.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 2 * delayStep, options: animationOption, animations: {
            self.loginButton.alpha = 1
        })
        
        // Adding login action after button is touched and showing error label if there is an error
        errorLabel = UILabel(); errorLabel.isHidden = true; errorLabel.textAlignment = .center
        errorLabel.text = "Wrong email or password"
        errorLabel.textColor = .white
        errorLabel.font = myFont
        loginButton.addAction(.init {
            _ in
            self.errorLabel.isHidden = true
            self.handleLogin()
        }, for: .touchUpInside)
        
        if !NetworkMonitor.shared.isConnected {
            noConnectionLabel.isHidden = false
            usernameField.isHidden = true
            passwordField.isHidden = true
            toggleButton.isHidden = true
            loginButton.isHidden = true
        }
        
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(toggleButton)
        view.addSubview(errorLabel)
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        titleLabel.addConstraints()
        
        noConnectionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: offset)
        noConnectionLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        noConnectionLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        
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
    
    private func handleLogin() {
        self.networkService.login(username: self.usernameField.text ?? "", password: self.passwordField.text ?? "") {
            (result: Result<LoginData, RequestError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.animateLogin()
//                    self.router.showQuizzesScreen()
                    break
                
                case .failure(let error):
                    print(error)
                    self.errorLabel.isHidden = false
                    break
                }
            }
        }
    }
    
    private func animateLogin(){
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationOption,
                       animations: {
                        self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -self.view.frame.height)
                       })
        UIView.animate(withDuration: animationDuration,
                       delay: delayStep,
                       options: animationOption,
                       animations: {
                        self.usernameField.transform = self.usernameField.transform.translatedBy(x: 0, y: -self.view.frame.height)
                       })
        UIView.animate(withDuration: animationDuration,
                       delay: 2 * delayStep,
                       options: animationOption,
                       animations: {
                        self.passwordField.transform = self.passwordField.transform.translatedBy(x: 0, y: -self.view.frame.height)
                        self.toggleButton.transform = self.toggleButton.transform.translatedBy(x: 0, y: -self.view.frame.height)
                       })
        UIView.animate(withDuration: animationDuration,
                       delay: 3 * delayStep,
                       options: animationOption,
                       animations: {
                        self.loginButton.transform = self.loginButton.transform.translatedBy(x: 0, y: -self.view.frame.height)
                       }, completion: { _ in self.router.showQuizzesScreen() })
        
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
