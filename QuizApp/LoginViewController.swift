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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
    }
    
    private func addGradientBackground(colors: CGColor...) {
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)

        gradient.frame = newView.bounds
        gradient.colors = colors

        newView.layer.insertSublayer(gradient, at: 0)
        view.addSubview(newView)
    }
    
    private func buildViews() {
        gradientView = GradientView(gradientStartColor: UIColor.white, gradientEndColor: UIColor.gray)
        
        titleLabel = UILabel()
        titleLabel.text = "QuizApp"
        titleLabel.textColor = .red
        
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
    }
    
    private func addConstraints() {
        gradientView.autoPinEdgesToSuperviewEdges()
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 50)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
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
