//
//  ios_training_Ryosuke1025Tests.swift
//  ios-training-Ryosuke1025Tests
//
//  Created by 須崎 良祐 on 2022/11/22.
//

import XCTest
@testable import ios_training_Ryosuke1025

class WeatherViewControllerTest: XCTestCase {
    var weatherViewController: WeatherViewController!
    let mock = WeatherModelMock()
    override func setUp() {
        super.setUp()
        weatherViewController = WeatherViewController.getInstance(weatherModel: mock)
        weatherViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        weatherViewController  = nil
    }
    
    // MARK: - Case Image
    
    func testSunny() {
        compareWithImage(weatherCondition: "sunny")
    }
    
    func testCloudy() {
        compareWithImage(weatherCondition: "cloudy")
    }
    
    func testRainy() {
        compareWithImage(weatherCondition: "rainy")
    }
    
    private func compareWithImage(weatherCondition: String) {
        mock.weatherCondition = weatherCondition
        mock.fetchWeather()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weatherCondition)?.withRenderingMode(.alwaysTemplate))
    }
    
    // MARK: - Case Label
    
    func testMaxTemperature() throws {
        mock.fetchWeather()
        let maxTemperatureText = try XCTUnwrap(weatherViewController.maxTemperature.text)
        XCTAssertEqual(maxTemperatureText, "25")
    }
    
    func testMinTemperature() throws {
        mock.fetchWeather()
        let minTemperatureText = try XCTUnwrap(weatherViewController.minTemperature.text)
        XCTAssertEqual(weatherViewController.minTemperature.text!, "7")
    }
}

class WeatherModelMock: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var weatherCondition: String = ""
    
    func fetchWeather() {
        delegate?.weatherModel(self, didFetchWeather: .init(maxTemperature: 25, date:"2020-04-01T12:00:00+09:00" , minTemperature: 7, weatherCondition: weatherCondition))
    }
}
