//
//  ViewController.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    private var weatherModel: WeatherModel
    @IBOutlet private(set) weak var weatherImage: UIImageView!
    @IBOutlet private(set) weak var maxTemperature: UILabel!
    @IBOutlet private(set) weak var minTemperature: UILabel!
    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.hidesWhenStopped = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func reloadWeatherImage(_ sender: Any) {
        self.indicator.startAnimating()
        weatherModel.fetchWeather()
    }
    
    @IBAction private func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Self Instance
    
    static func getInstance(weatherModel: WeatherModel) -> WeatherViewController? {
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        let weatherViewController = storyboard.instantiateInitialViewController { coder in
            WeatherViewController(coder: coder, weatherModel: weatherModel)
        }
        return weatherViewController
    }
    
    // MARK: - Init
    
    init?(coder: NSCoder, weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinit
    
    deinit {
        print("WeatherViewController is deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNotification()
    }
    
    // MARK: - Notification Center
    
    private func setNotification() {
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
        DispatchQueue.main.async {
            switch weather.weatherCondition {
            case "sunny":
                self.weatherImage.tintColor = .systemRed
                self.weatherImage.image = UIImage(named: "sunny")?.withRenderingMode(.alwaysTemplate)
            
            case "cloudy":
                self.weatherImage.tintColor = .systemGray
                self.weatherImage.image = UIImage(named: "cloudy")?.withRenderingMode(.alwaysTemplate)
            
            case "rainy":
                self.weatherImage.tintColor = .systemBlue
                self.weatherImage.image = UIImage(named: "rainy")?.withRenderingMode(.alwaysTemplate)
            
            default:
                self.weatherImage.tintColor = .systemPurple
                self.weatherImage.image = UIImage(named: "question")?.withRenderingMode(.alwaysTemplate)
            }
            
            self.maxTemperature.text = String(weather.maxTemperature)
            self.minTemperature.text = String(weather.minTemperature)
            
            self.indicator.stopAnimating()
        }
    }
    
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "エラーが発生しました", message: error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.indicator.stopAnimating()
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
