//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Marin on 22.04.2021..
//

import UIKit

class SettingsViewController: UIViewController {
    private var gradientView: GradientView!
    private var usernameLabel: UILabel!
    private var usernameText: UILabel!
    private var logoutButton: UIButton!
    
    private var buttonWidth: CGFloat = 300
    private var buttonHeight: CGFloat = 40
    private var cornerRadius: CGFloat = 20
    private let myFontBold = UIFont(name: "ArialRoundedMTBold", size: 20)
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var router: AppRouterProtocol!

    convenience init(router: AppRouterProtocol) {
        self.init()
        
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        addConstraints()
    }
    
    private func buildViews() {
        gradientView = GradientView(superView: view)
        
        usernameLabel = UILabel()
        view.addSubview(usernameLabel)
        usernameLabel.text = "USERNAME"
        usernameLabel.font = myFontBold
        usernameLabel.textColor = .white
        
        usernameText = UILabel()
        view.addSubview(usernameText)
        usernameText.text = "Marin Hrkec"
        usernameText.font = myFont
        usernameText.textColor = .white
        
        logoutButton = UIButton()
        view.addSubview(logoutButton)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(gradientView.getGradientEndColor(), for: .normal)
        logoutButton.titleLabel?.font = myFont
        logoutButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        logoutButton.layer.cornerRadius = cornerRadius
        logoutButton.addAction(.init {
            _ in
            self.router.logout()
        }, for: .touchUpInside)
    }
    
    private func addConstraints() {
        usernameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        usernameLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 15)
        usernameLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 15)
        
        usernameText.autoPinEdge(.top, to: .bottom, of: usernameLabel)
        usernameText.autoPinEdge(.leading, to: .leading, of: usernameLabel)
        usernameText.autoPinEdge(.trailing, to: .trailing, of: usernameLabel)
        
        logoutButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        logoutButton.autoAlignAxis(toSuperviewAxis: .vertical)
        logoutButton.autoSetDimension(.width, toSize: buttonWidth)
        logoutButton.autoSetDimension(.height, toSize: buttonHeight)
    }
}
