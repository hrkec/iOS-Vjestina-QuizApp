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
    
    private func buildView() {
        font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
        text = "QuizApp"
        textAlignment = .center
        textColor = .white

    }
    
    func addConstraints() {
        autoPinEdge(toSuperviewEdge: .top, withInset: 40)
        autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
