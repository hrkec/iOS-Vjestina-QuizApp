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
    private var quizTableView: UITableView!
    
    private var buttonWidth: CGFloat = 250
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    
    private var quizzes: [Quiz] = []
    private var nbas: Int = 0
    private var numOfCategories: Int = 0
    private var numberOfQuizzesPerCategory: [QuizCategory: Int] = [:]
    private var idToCategory: [Int: QuizCategory] = [:]
    
    private var quizCount: Int = 0
    
    private let cellIdentifier = "quizTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView(gradientStartColor: UIColor.white, gradientEndColor: UIColor.gray)
        
        // Building a label with the app title
        titleLabel = TitleLabel()
        
        funFactLabel = UILabel()
        funFactLabel.isHidden = true
        funFactLabel.text = "Fun Fact"
        funFactLabel.numberOfLines = 0
        funFactLabel.lineBreakMode = .byWordWrapping
        
        getQuizButton = UIButton()
        getQuizButton.setTitle("Get Quiz", for: .normal)
        getQuizButton.setTitleColor(.black, for: .normal)
        getQuizButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        getQuizButton.layer.cornerRadius = cornerRadius
        getQuizButton.layer.borderWidth = 1.0
        
        quizTableView = UITableView()
        quizTableView.isHidden = true
        
        getQuizButton.addAction(.init {
            _ in
            self.quizzes = DataService().fetchQuizes()
            self.funFactLabel.isHidden = false
            self.quizTableView.isHidden = false
            self.quizTableView = UITableView()
            self.nbas = 0
            self.quizCount = 0
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
            self.funFactLabel.text = "Fun Fact\nThere are \(self.nbas) questions that contain word \"NBA\""
            
            self.numOfCategories = self.numberOfQuizzesPerCategory.keys.count
            self.view.addSubview(self.quizTableView)
            
            self.quizTableView.register(QuizTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
            self.quizTableView.dataSource = self
            
            self.quizTableView.autoPinEdge(.top, to: .bottom, of: self.funFactLabel, withOffset: 20)
            self.quizTableView.autoPinEdge(toSuperviewEdge: .bottom)
            self.quizTableView.autoPinEdge(toSuperviewEdge: .trailing)
            self.quizTableView.autoPinEdge(toSuperviewEdge: .leading)
            self.quizTableView.rowHeight = 120
        }, for: .touchUpInside)
        
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
        view.addSubview(getQuizButton)
        view.addSubview(funFactLabel)
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
        funFactLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
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
        
        var sum: Int = 0
        if(indexPath.section != 0) {
            for i in 0...indexPath.section {
                sum += self.numberOfQuizzesPerCategory[self.idToCategory[i]!]!
            }
            sum -= 1
        }
        
        // pretpostavimo da su kvizovi vec sortirani po kategorijama!!! Sortirati ih? provjeravati???
        cell.set(quiz: quizzes[sum + indexPath.row])
        
        
//        cell.set(quiz: quizzes[self.quizCount])
//        self.quizCount += 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.idToCategory[section]!.rawValue
    }
    
}
