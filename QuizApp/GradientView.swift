//
//  GradientView.swift
//  QuizApp
//
//  Created by Marin on 20.04.2021..
//

import UIKit

class GradientView: UIView {
    private let gradient: CAGradientLayer = CAGradientLayer()
    private let gradientStartColor: UIColor
    private let gradientEndColor: UIColor
    
    init(gradientStartColor: UIColor, gradientEndColor: UIColor){
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        super.init(frame: .zero)
    }
    
    convenience init() {
        let gradientStartColor = UIColor(red: 0.87, green: 0.32, blue: 0.32, alpha: 1.00)
        let gradientEndColor = UIColor(red: 0.39, green: 0.03, blue: 0.03, alpha: 1.00)
        self.init(gradientStartColor: gradientStartColor, gradientEndColor: gradientEndColor)
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
    
    func addConstraints() {
        autoPinEdgesToSuperviewEdges()
    }
    
    func getGradientStartColor() -> UIColor {
        return gradientStartColor
    }
    
    func getGradientEndColor() -> UIColor {
        return gradientEndColor
    }
}
