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
    private let myFont: UIFont! = UIFont(name: "ArialMT", size: UILabel().font.pointSize)
    
    private var quizzes: [Quiz] = []
    private var nbas: Int = 0
    private var numOfCategories: Int = 0
    private var numberOfQuizzesPerCategory: [QuizCategory: Int] = [:]
    private var idToCategory: [Int: QuizCategory] = [:]
    
    private var byCategory: [QuizCategory: [Quiz]]!
    
    private var router: AppRouterProtocol!
    private var networkService: NetworkServiceProtocol!
    
    private let cellIdentifier = "quizTableCell"
    
    convenience init(router: AppRouterProtocol, networkService: NetworkServiceProtocol) {
        self.init()
        
        self.router = router
        self.networkService = networkService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        addConstraints()
    }
    
    private func buildViews() {
        // Building gradient view for gradient background
        gradientView = GradientView()
        view.addSubview(gradientView)
        
        // Building a label with the app title
        titleLabel = TitleLabel()
        view.addSubview(titleLabel)
        
        funFactLabel = UILabel()
        funFactLabel.isHidden = true
        funFactLabel.text = "💡 Fun Fact"
        funFactLabel.textColor = .white
        funFactLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
        
        // Building a "fun fact" label
        funFactText = UILabel()
        funFactText.isHidden = true
        funFactText.numberOfLines = 0
        funFactText.lineBreakMode = .byWordWrapping
        funFactText.textColor = .white
        funFactText.font = myFont
        
        // Building a button for fetching quizzes
        getQuizButton = UIButton()
        getQuizButton.setTitle("Get Quiz", for: .normal)
        getQuizButton.setTitleColor(.white, for: .normal)
        getQuizButton.titleLabel?.font = myFont
        getQuizButton.layer.backgroundColor = CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        getQuizButton.layer.cornerRadius = cornerRadius
        
        // Building a table view for fetched quizzes
        quizTableView = UITableView()
        quizTableView.isHidden = true
        quizTableView.layer.cornerRadius = 15
        quizTableView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        quizTableView.register(QuizTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        quizTableView.dataSource = self
        quizTableView.delegate = self
        quizTableView.rowHeight = 120
        
        // Action when Get Quiz button is clicked
        getQuizButton.addTarget(self, action: #selector(getQuizAction), for: .touchUpInside)

        view.addSubview(quizTableView)
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
        
        quizTableView.autoPinEdge(.top, to: .bottom, of: funFactText, withOffset: 20)
        quizTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        quizTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        quizTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
    }
    
    @objc final func getQuizAction(sender: UIButton!) {
        networkService.fetchQuizzes() {
            (result: Result<[Quiz], RequestError>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                    break
                case .success(let quizzes):
                    self.quizzes = quizzes
                    self.funFactLabel.isHidden = false
                    self.funFactText.isHidden = false
                    self.quizTableView.isHidden = false
                    
                    self.nbas = 0
                    self.numberOfQuizzesPerCategory = [:]
                    
                    var categories: Set<QuizCategory> = []
                    var categoryId: Int = 0
                    
                    self.byCategory = Dictionary(grouping: self.quizzes, by: { $0.category })
                    
                    for quiz in self.quizzes {
                        for question in quiz.questions {
                            if question.question.contains("NBA") {
                                self.nbas += 1
                            }
                        }
                        
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
                    self.funFactText.text = "There are \(self.nbas) questions that contain word \"NBA\""
                    self.quizTableView.reloadData()
                }
            }
            
        }
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

extension QuizzesViewController: UITableViewDelegate {
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

extension UIColor {
    class func randomColor(randomAlpha: Bool = false) -> UIColor {
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let alphaValue = randomAlpha ? CGFloat(arc4random_uniform(255)) / 255.0 : 1;

        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }
}
