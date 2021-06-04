//
//  SearchQuizViewController.swift
//  QuizApp
//
//  Created by Marin on 30.05.2021..
//

import Foundation
import UIKit

class SearchQuizViewController: UIViewController{
    private var gradientView: GradientView!
    private var quizTableView: UITableView!
    private var searchBarView: SearchBarView!
    private var searchButton: UIButton!
    
    private var buttonWidth: CGFloat = 250
    private var buttonHeight: CGFloat = 40
    private var offset: CGFloat = 20
    private var cornerRadius: CGFloat = 20
    private let myFont: UIFont! = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var quizzes: [Quiz] = []
    private var numOfCategories: Int = 0
    private var numberOfQuizzesPerCategory: [QuizCategory: Int] = [:]
    private var idToCategory: [Int: QuizCategory] = [:]
    
    private var byCategory: [QuizCategory: [Quiz]]!
//    private var currentFilterSettings: FilterSettings
    
    private var router: AppRouterProtocol!
    private var quizDataRepository: QuizRepositoryProtocol!
    
    private let cellIdentifier = "quizTableCell"
    
    convenience init(router: AppRouterProtocol, quizDataRepository: QuizRepositoryProtocol) {
        self.init()
        
        self.router = router
        self.quizDataRepository = quizDataRepository
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(filter: FilterSettings(searchText: ""))
        buildViews()
        addConstraints()
    }
    
    private func fetchData(filter: FilterSettings) {
        self.quizzes = quizDataRepository.fetchData(filter: filter)
        DispatchQueue.main.async {
            self.numberOfQuizzesPerCategory = [:]
            
            var categories: Set<QuizCategory> = []
            var categoryId: Int = 0
            
            self.byCategory = Dictionary(grouping: self.quizzes, by: { $0.category })
            
            for quiz in self.quizzes {
                // Add categories to set of categories and enumerate them
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
            self.numOfCategories = self.numberOfQuizzesPerCategory.keys.count
            self.quizTableView.reloadData()
        }
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView()
        view.addSubview(gradientView)
        
        searchBarView = SearchBarView()
        view.addSubview(searchBarView)
        
        searchButton = UIButton()
        view.addSubview(searchButton)
        searchButton.setTitle("Search", for: .normal)
        searchButton.titleLabel?.font = myFont
        searchButton.layer.backgroundColor = .none
        searchButton.layer.cornerRadius = cornerRadius
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        // Building a table view for fetched quizzes
        quizTableView = UITableView()
        view.addSubview(quizTableView)
        quizTableView.layer.cornerRadius = 15
        quizTableView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        quizTableView.register(QuizTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        quizTableView.dataSource = self
        quizTableView.delegate = self
        quizTableView.rowHeight = 120
    }
    
    private func addConstraints() {
        gradientView.addConstraints()
        
        searchBarView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        searchBarView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 5)
        searchBarView.autoSetDimension(.height, toSize: buttonHeight)
        
        searchButton.autoAlignAxis(.horizontal, toSameAxisOf: searchBarView)
        searchButton.autoPinEdge(.leading, to: .trailing, of: searchBarView)
        searchButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        searchButton.autoSetDimension(.width, toSize: 70)
    
        quizTableView.autoPinEdge(.top, to: .bottom, of: searchBarView, withOffset: offset)
        quizTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: offset)
        quizTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        quizTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
    }
    
    @objc final func handleSearch(sender: UIButton!) {
        fetchData(filter: FilterSettings(searchText: searchBarView.getSearchText()))
        self.quizTableView.reloadData()
    }
    
}

extension SearchQuizViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.numOfCategories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfQuizzesPerCategory[self.idToCategory[section]!] ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuizTableViewCell
        
        cell.backgroundColor = .clear
        
        var quiz: Quiz!
        if let category = self.idToCategory[indexPath.section] {
            if let quizzesOfCategory = self.byCategory[category] {
                quiz = quizzesOfCategory[indexPath.row]
            }
        }
        cell.set(quiz: quiz, font: self.myFont)
        
        return cell
    }
}

extension SearchQuizViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var quiz: Quiz!
        if let category = self.idToCategory[indexPath.section] {
            if let quizzesOfCategory = self.byCategory[category] {
                quiz = quizzesOfCategory[indexPath.row]
            }
        }
        
        router.showSelectedQuizScreen(quiz: quiz)
    }
    
    // Custom header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let label = UILabel()
        label.frame = CGRect()
        label.text = self.idToCategory[section]!.rawValue
        label.font = myFont?.withSize(18)
        label.textColor = UIColor.randomColor()
        label.backgroundColor = .clear
        
        headerView.addSubview(label)
        
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        label.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
