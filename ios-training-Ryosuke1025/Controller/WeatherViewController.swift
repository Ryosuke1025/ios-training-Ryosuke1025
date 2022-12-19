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
        self.updateWeather()
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
            self.updateWeather()
        }
    }
    
    @objc func viewDidEnterBackground(_ notification: Notification) {
        if self.isViewLoaded && self.view.window != nil {
            print("バックグラウンド")
        }
    }
    
    func updateWeather() {
        WeatherModel().fetchWeather(completionHandler: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    switch response.weatherCondition {
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
                    self.maxTemperature.text = String(response.maxTemperature)
                    self.minTemperature.text = String(response.minTemperature)
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case APIError.invalidParameter:
                        errorMessage = "もう一度reloadボタンをタップしてください"
                    case APIError.unknown:
                        errorMessage = "予期しないエラーが発生しました"
                    default:
                        errorMessage = "予期しないエラーが発生しました"
                    }
                    let alertController = UIAlertController(title: "エラーが発生しました", message: errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                self.indicator.stopAnimating()
            }
        })
    }
}
