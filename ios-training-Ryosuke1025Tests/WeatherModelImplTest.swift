//
//  WeatherModelImplTest.swift
//  ios-training-Ryosuke1025Tests
//
//  Created by 須崎 良祐 on 2022/12/12.
//

import XCTest
@testable import ios_training_Ryosuke1025

class WeatherModelImplTest: XCTestCase {
    var weatherModelImpl: WeatherModelImpl!
    
    override func setUp() {
        super.setUp()
        weatherModelImpl = WeatherModelImpl()
    }
    
    override func tearDown() {
        super.tearDown()
        weatherModelImpl = nil
    }

    // MARK: - Case Json
    
    func testEncode() {
        let area = "tokyo"
        let date = "2020-04-01T12:00:00+09:00"
        let request = RequestModel(area: area, date: date)
        let expect = #"{"area":"\#(area)","date":"\#(date)"}"#.data(using: .utf8)!
        XCTAssertEqual(weatherModelImpl.encode(request: request), expect)
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
        XCTAssertEqual(weatherModelImpl.decode(responseData: responseData), expect)
    }
}
