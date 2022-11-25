//
//  ViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import UIKit
import YumemiWeather

final class ViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    //MARK: - Actions
    
    @IBAction func reloadWeatherImage(_ sender: Any) {
        updateWeather()
    }
    
    @IBAction func close(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EmptyView", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "EmptyView")
        self.dismiss(animated: true)
        //self.present(nextVC, animated: true, completion: nil)
    }
}

extension ViewController {
    
    //MARK: - Methods
    
    private func updateWeather(){
        let weather = YumemiWeather.fetchWeatherCondition()
        switch weather {
        case "sunny":
            weatherImage.tintColor = .systemRed
            weatherImage.image = UIImage(named: "sunny")?.withRenderingMode(.alwaysTemplate)
        
        case "cloudy":
            weatherImage.tintColor = .systemGray
            weatherImage.image = UIImage(named: "cloudy")?.withRenderingMode(.alwaysTemplate)
        case "rainy":
            weatherImage.tintColor = .systemBlue
            weatherImage.image = UIImage(named: "rainy")?.withRenderingMode(.alwaysTemplate)
        
        default:
            weatherImage.tintColor = .systemPurple
            weatherImage.image = UIImage(named: "question")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
