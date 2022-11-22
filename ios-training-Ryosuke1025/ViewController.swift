//
//  ViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttounHStack: UIStackView!
    @IBOutlet weak var constraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let imageWidth = self.view.frame.size.width / 2
        constraints.constant = imageWidth
        buttounHStack.spacing = 20
    }

}

