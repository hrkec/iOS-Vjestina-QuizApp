//
//  QuizTableViewCell.swift
//  QuizApp
//
//  Created by Marin on 07.04.2021..
//

import Foundation
import UIKit

// Custom cell class for TableView
// It contains image, title, description and level of quiz
class QuizTableViewCell: UITableViewCell {
    
    var quiz: Quiz!
    var quizImageView: UIImageView! = UIImageView(image: UIImage(named: "quiz"))
    var quizTitleLabel = UILabel()
    var quizDescriptionLabel = UILabel()
    var quizLevelLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(quizImageView)
        addSubview(quizTitleLabel)
        addSubview(quizDescriptionLabel)
        addSubview(quizLevelLabel)
        
        configureViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(quiz: Quiz) {
        self.quiz = quiz
        quizTitleLabel.text = quiz.title
        quizLevelLabel.text = "Level \(String(quiz.level))/3"
        quizDescriptionLabel.text = quiz.description
    }
    
    func set(quiz: Quiz, font: UIFont) {
        set(quiz: quiz)
        quizTitleLabel.font = font.withSize(20)
        quizLevelLabel.font = font
        quizDescriptionLabel.font = font
    }
    
    private func configureViews() {
        quizImageView.layer.cornerRadius = 10
        quizImageView.clipsToBounds = true
        
        quizTitleLabel.textColor = .white
        quizTitleLabel.lineBreakMode = .byWordWrapping
        quizTitleLabel.numberOfLines = 0
        
        quizDescriptionLabel.lineBreakMode = .byWordWrapping
        quizDescriptionLabel.textColor = .white
        quizDescriptionLabel.numberOfLines = 0
        
        quizLevelLabel.textColor = .white
    }
    
    private func addConstraints() {
        quizImageView.translatesAutoresizingMaskIntoConstraints = false
        quizImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        quizImageView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        quizImageView.autoSetDimension(.height, toSize: 80)
        quizImageView.autoSetDimension(.width, toSize: 80)

        quizTitleLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: 10)
        quizTitleLabel.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 20)
        quizTitleLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: 5)

        quizDescriptionLabel.autoPinEdge(.top, to: .bottom, of: quizTitleLabel, withOffset: 10)
        quizDescriptionLabel.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 20)
        quizDescriptionLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: 5)
        
        quizLevelLabel.autoPinEdge(.top, to: .bottom, of: quizDescriptionLabel)
        quizLevelLabel.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 20)
    }
}
