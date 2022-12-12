//
//  EmptyViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/25.
//

import UIKit
final class EmptyViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let safeNextVC = WeatherViewController.getInstance(weatherModel: WeatherModelImpl()) else { return }
        safeNextVC.modalPresentationStyle = .fullScreen
        present(safeNextVC, animated: true, completion: nil)
    }
}
