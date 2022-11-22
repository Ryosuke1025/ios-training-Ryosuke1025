//
//  ViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import UIKit
import YumemiWeather
class ViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBAction func Reload(_ sender: Any) {
        indicateWeather()
    }
}

extension ViewController {
    private func indicateWeather(){
        let weather = YumemiWeather.fetchWeatherCondition()
        if weather == "sunny" {
            weatherImage.tintColor = .red
            weatherImage.image = UIImage(named: "sunny")?.withRenderingMode(.alwaysTemplate)
        } else if weather == "cloudy" {
            weatherImage.tintColor = .gray
            weatherImage.image = UIImage(named: "cloudy")?.withRenderingMode(.alwaysTemplate)
        } else {
            weatherImage.tintColor = .blue
            weatherImage.image = UIImage(named: "rainy")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
