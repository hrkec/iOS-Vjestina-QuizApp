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
        
        navigationItem.title = "QuizApp"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: myFontBold!, NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleReturnButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func handleReturnButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView(superView: view)
        
    }
    
    private func addConstraints() {
        
        
    }
}
