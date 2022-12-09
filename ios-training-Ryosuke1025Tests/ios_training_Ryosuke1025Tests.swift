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
        weatherViewController = WeatherViewController.getWeatherViewControllerInstance(weatherModel: mock)
        weatherViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Case Image
    
    private func testSunny() {
        compareWithImage(weatherCondition: "sunny")
    }
    
    private func testCloudy() {
        compareWithImage(weatherCondition: "cloudy")
    }
    
    private func testRainy() {
        compareWithImage(weatherCondition: "rainy")
    }
    
    private func compareWithImage(weatherCondition: String) {
        mock.weatherCondition = weatherCondition
        mock.fetchWeather()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weatherCondition)?.withRenderingMode(.alwaysTemplate))
    }
    
    // MARK: - Case Label
    
    private func testMaxTemperature() {
        mock.fetchWeather()
        XCTAssertEqual(Int(weatherViewController.maxTemperature.text!), 25)
    }
    
    private func testMinTemperature() {
        mock.fetchWeather()
        XCTAssertEqual(Int(weatherViewController.minTemperature.text!), 7)
    }
}

class WeatherModelMock: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var weatherCondition: String = ""
    
    func fetchWeather() {
        delegate?.weatherModel(self, didFetchWeather: .init(maxTemperature: 25, date:"2020-04-01T12:00:00+09:00" , minTemperature: 7, weatherCondition: weatherCondition))
    }
}
