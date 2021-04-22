//
//  TitleLabel.swift
//  QuizApp
//
//  Created by Marin on 20.04.2021..
//

import Foundation
import UIKit

class TitleLabel: UILabel {
    init(superView: UIView) {
        super.init(frame: .zero)
        buildView()
        superView.addSubview(self)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
//        font = UIFont.boldSystemFont(ofSize: 20.0)
        text = "QuizApp"
        textAlignment = .center
        textColor = .white
//        adjustsFontSizeToFitWidth = true
    }
    
    private func addConstraints() {
        autoPinEdge(toSuperviewEdge: .top, withInset: 40)
//        autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
