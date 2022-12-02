//
//  ViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    let weatherModel = WeatherModel()
    @IBOutlet weak var weatherImage: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func reloadWeatherImage(_ sender: Any) {
        weatherModel.fetchWeather()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Deinit
    
    deinit {
        print("WeatherViewController is deinit")
    }
}

extension WeatherViewController: WeatherModelDelegate {
    
    // MARK: - Methods
    
    func weatherModel(_ weatherModel: WeatherModel, didFetchWeather weather: String) {
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
    
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: String) {
        let alertController = UIAlertController(title: "エラーが発生しました", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
