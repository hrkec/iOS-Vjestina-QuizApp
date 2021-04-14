//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Marin on 07.04.2021..
//

import Foundation
import UIKit

class QuizzesViewController: UIViewController {
    private var titleLabel: TitleLabel!
    private var gradientView: GradientView!
    private var getQuizButton: UIButton!
    private var funFactLabel: UILabel!
    private var funFactText: UILabel!
    private var quizTableView: UITableView!
    
    private var buttonWidth: CGFloat = 250
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    private let myFont = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var quizzes: [Quiz] = []
    private var nbas: Int = 0
    private var numOfCategories: Int = 0
    private var numberOfQuizzesPerCategory: [QuizCategory: Int] = [:]
    private var idToCategory: [Int: QuizCategory] = [:]
    
    private let cellIdentifier = "quizTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView()
        
        // Building a label with the app title
        titleLabel = TitleLabel()
        
        funFactLabel = UILabel()
        funFactLabel.isHidden = true
        funFactLabel.text = "💡 Fun Fact"
        funFactLabel.textColor = .white
        funFactLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
        
        funFactText = UILabel()
        funFactText.isHidden = true
        funFactText.numberOfLines = 0
        funFactText.lineBreakMode = .byWordWrapping
        funFactText.textColor = .white
        funFactText.font = myFont
        
        getQuizButton = UIButton()
        getQuizButton.setTitle("Get Quiz", for: .normal)
        getQuizButton.setTitleColor(.black, for: .normal)
        getQuizButton.titleLabel?.font = myFont
        getQuizButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        getQuizButton.layer.cornerRadius = cornerRadius
        
        quizTableView = UITableView()
        quizTableView.isHidden = true
        
        getQuizButton.addAction(.init {
            _ in
            self.quizzes = DataService().fetchQuizes()
            self.funFactLabel.isHidden = false
            self.funFactText.isHidden = false
            self.quizTableView.isHidden = false
            self.quizTableView.reloadData()
            self.nbas = 0
            self.numberOfQuizzesPerCategory = [:]
            
            var categories: Set<QuizCategory> = []
            var categoryId: Int = 0
            
            for quiz in self.quizzes {
                for question in quiz.questions {
                    if question.question.contains("NBA") {
                        self.nbas += 1
                    }
                }
                
                if !categories.contains(quiz.category) {
                    self.idToCategory[categoryId] = quiz.category
                    categoryId += 1
                    categories.insert(quiz.category)
                }
                
                if let _ = self.numberOfQuizzesPerCategory[quiz.category] {
                    self.numberOfQuizzesPerCategory[quiz.category]! += 1
                } else {
                    self.numberOfQuizzesPerCategory[quiz.category] = 1
                }
            }
            self.quizTableView.layer.cornerRadius = 15
//            self.quizTableView.backgroundColor = .clear
            self.quizTableView.backgroundColor = UIColor(white: 1, alpha: 0.3)
            
            self.funFactText.text = "There are \(self.nbas) questions that contain word \"NBA\""
            
            self.numOfCategories = self.numberOfQuizzesPerCategory.keys.count
            self.view.addSubview(self.quizTableView)
            
            self.quizTableView.register(QuizTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
            self.quizTableView.dataSource = self
            
            self.quizTableView.autoPinEdge(.top, to: .bottom, of: self.funFactText, withOffset: 20)
            self.quizTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
            self.quizTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            self.quizTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            self.quizTableView.rowHeight = 120
        }, for: .touchUpInside)
        
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
        view.addSubview(getQuizButton)
        view.addSubview(funFactLabel)
        view.addSubview(funFactText)
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        titleLabel.addConstraints()
        
        getQuizButton.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: offset)
        getQuizButton.autoAlignAxis(toSuperviewAxis: .vertical)
        getQuizButton.autoSetDimension(.width, toSize: buttonWidth)
        getQuizButton.autoSetDimension(.height, toSize: buttonHeight)
        
        funFactLabel.autoPinEdge(.top, to: .bottom, of: getQuizButton, withOffset: offset)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        funFactText.autoPinEdge(.top, to: .bottom, of: funFactLabel, withOffset: 5)
        funFactText.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        funFactText.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
    }
}

extension QuizzesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.numOfCategories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfQuizzesPerCategory[self.idToCategory[section]!] ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuizTableViewCell
        
        cell.backgroundColor = .clear
        
        var sum: Int = 0
        if(indexPath.section != 0) {
            for i in 0...indexPath.section {
                sum += self.numberOfQuizzesPerCategory[self.idToCategory[i]!]!
            }
            sum -= 1
        }
        
        // pretpostavimo da su kvizovi vec sortirani po kategorijama!!! Sortirati ih? provjeravati???
        cell.set(quiz: quizzes[sum + indexPath.row], font:self.myFont!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.idToCategory[section]!.rawValue
    }

}
