//
//  TitleLabel.swift
//  QuizApp
//
//  Created by Marin on 20.04.2021..
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
        font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
//        font = UIFont.boldSystemFont(ofSize: 20.0)
        text = "QuizApp"
        textAlignment = .center
        textColor = .white
//        adjustsFontSizeToFitWidth = true
    }
    
    func addConstraints() {
//        autoPinEdge(toSuperviewEdge: .top, withInset: 60)
        autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
