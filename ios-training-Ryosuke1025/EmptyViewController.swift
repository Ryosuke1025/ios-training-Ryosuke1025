//
//  EmptyViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/25.
//

import UIKit
class EmptyViewController: UIViewController {
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        // 画面初期化処理を書く
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面表示前の処理を書く
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 画面表示直後の処理を書く
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "WeatherView")
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面非表示直前の処理を書く
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 画面非表示直後の処理を書く
    }
}
