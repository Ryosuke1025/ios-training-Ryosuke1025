//
//  ViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    private var weatherModel: WeatherModel
    @IBOutlet private(set) weak var weatherImage: UIImageView!
    @IBOutlet private weak var maxTemperature: UILabel!
    @IBOutlet private weak var minTemperature: UILabel!
    
    static func getNextViewController(weatherModel: WeatherModel) -> WeatherViewController? {
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController { coder in
            WeatherViewController(coder: coder, weatherModel: weatherModel)
        }
        return nextVC
    }
    
    init?(coder: NSCoder, weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNotificasion()
    }
    
    // MARK: - Actions
    
    @IBAction private func reloadWeatherImage(_ sender: Any) {
        weatherModel.fetchWeather()
    }
    
    @IBAction private func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Deinit
    
    deinit {
        print("WeatherViewController is deinit")
    }
    
    // MARK: - Notification Center
    
    func setNotificasion() {
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        if self.isViewLoaded && self.view.window != nil {
            weatherModel.fetchWeather()
        }
    }
    
    @objc func viewDidEnterBackground(_ notification: Notification) {
        if self.isViewLoaded && self.view.window != nil {
            print("バックグラウンド")
        }
    }
}

extension WeatherViewController: WeatherModelDelegate {
    
    // MARK: - Methods
    
    func weatherModel(_ weatherModel: WeatherModel, didFetchWeather weather: ResponseModel) {
        switch weather.weatherCondition {
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
        
        maxTemperature.text = String(weather.maxTemperature)
        minTemperature.text = String(weather.minTemperature)
    }
    
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: String) {
        let alertController = UIAlertController(title: "エラーが発生しました", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
