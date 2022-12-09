//
//  ios_training_Ryosuke1025Tests.swift
//  ios-training-Ryosuke1025Tests
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import XCTest
@testable import ios_training_Ryosuke1025

class SimpleApplicationTests: XCTestCase {
    var weatherViewController: WeatherViewController!
    let mock = WeatherModelMock()
    override func setUp() {
        super.setUp()
        weatherViewController = WeatherViewController.getNextViewController(weatherModel: mock)
        weatherViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test晴れであることを確認する() {
        let weather = "sunny"
        mock.weather = weather
        mock.fetchWeather()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weather)?.withRenderingMode(.alwaysTemplate))
    }
    
    func test曇りであることを確認する() {
        let weather = "cloudy"
        mock.weather = weather
        mock.fetchWeather()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weather)?.withRenderingMode(.alwaysTemplate))
    }
    
    func test雨であることを確認する() {
        let weather = "rainy"
        mock.weather = weather
        mock.fetchWeather()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weather)?.withRenderingMode(.alwaysTemplate))
    }
}

class WeatherModelMock: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var weather: String = ""
    
    func fetchWeather() {
        delegate?.weatherModel(self, didFetchWeather: .init(maxTemperature: 25, date:"2020-04-01T12:00:00+09:00" , minTemperature: 7, weatherCondition: weather))
    }
}
