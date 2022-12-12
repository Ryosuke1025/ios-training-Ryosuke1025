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
    
    func testMaxTemperature() {
        mock.fetchWeather()
        XCTAssertEqual(Int(weatherViewController.maxTemperature.text!), 25)
    }
    
    func testMinTemperature() {
        mock.fetchWeather()
        XCTAssertEqual(Int(weatherViewController.minTemperature.text!), 7)
    }
    
    // MARK: - Case Json
    
    func testEncode() {
        let area = "tokyo"
        let date = "2020-04-01T12:00:00+09:00"
        let request = RequestModel(area: area, date: date)
        let expect = """
        {
            "area": "\(area)",
            "date": "\(date)"
        }
        """.data(using: .utf8)!
        XCTAssertEqual(mock.encode(request: request), expect)
    }
    
    func testDecode() {
        let responseData = """
        {
            "maxTemperature": 25,
            "date": "2020-04-01T12:00:00+09:00",
            "minTemperature": 7,
            "weatherCondition": "Sunny"
        }
        """.data(using: .utf8)!
        let expect = ResponseModel(maxTemperature: 25, date: "2020-04-01T12:00:00+09:00", minTemperature: 7, weatherCondition: "Sunny")
        XCTAssertEqual(mock.decode(responseData: responseData), expect)
    }
}

class WeatherModelMock: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var weatherCondition: String = ""
    
    func fetchWeather() {
        delegate?.weatherModel(self, didFetchWeather: .init(maxTemperature: 25, date:"2020-04-01T12:00:00+09:00" , minTemperature: 7, weatherCondition: weatherCondition))
    }
    
    func encode(request: RequestModel) -> Data {
        let encoder = JSONEncoder()
        let requestData = try? encoder.encode(request)
        return requestData!
    }
    
    func decode(responseData: Data) -> ResponseModel {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try? decoder.decode(ResponseModel.self, from: responseData)
        return response!
    }
}
