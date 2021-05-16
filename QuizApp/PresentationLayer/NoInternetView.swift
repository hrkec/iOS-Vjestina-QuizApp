//
//  NoInternetView.swift
//  QuizApp
//
//  Created by Marin on 16.05.2021..
//

import Foundation
import UIKit

class NoInternetView: UIView {
    private var textLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        textLabel = UILabel()
        addSubview(textLabel)
        
        textLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
        textLabel.text = "No Internet connection"
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0

    }
}
