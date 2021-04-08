//
//  Util.swift
//  QuizApp
//
//  Created by Marin on 07.04.2021..
//

import Foundation
import UIKit

class TitleLabel: UILabel {
    init() {
        super.init(frame: .zero)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildView() {
        text = "QuizApp"
        textAlignment = .center
        textColor = .red
        adjustsFontSizeToFitWidth = true
    }
    
    func addConstraints() {
        autoPinEdge(toSuperviewEdge: .top, withInset: 60)
        autoAlignAxis(toSuperviewAxis: .vertical)
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
    
    func addConstraints() {
        autoPinEdgesToSuperviewEdges()
    }
}
