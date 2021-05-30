//
//  SearchBarView.swift
//  QuizApp
//
//  Created by Five on 30.05.2021..
//

import UIKit

class SearchBarView: UITextFieldWithPadding {
    private var buttonWidth: CGFloat = 70
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    convenience init() {
        self.init(frame: .zero)
        buildView()
    }
    
    private func setLayer() {
        self.layer.cornerRadius = CGFloat(5)
        self.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
    }
    
    private func buildView() {
        let textFieldBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        attributedPlaceholder = NSAttributedString(string: "Type here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        layer.cornerRadius = cornerRadius
        textColor = .white
        backgroundColor = textFieldBackgroundColor
    }

    func getSearchText() -> String {
        return text ?? ""
    }
}

