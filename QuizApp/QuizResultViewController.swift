//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Marin on 22.04.2021..
//

import UIKit

class QuizResultViewController: UIViewController {
    
    private var router: AppRouterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Onemoguci povratak na prosli ekran
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        
        self.router = router
    }

}
