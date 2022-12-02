//
//  WeatherModel.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/29.
//

import Foundation
import YumemiWeather

protocol WeatherModelDelegate: AnyObject {
    func weatherModel(_ weatherModel: WeatherModel, didFetchWeather weather: Weather)
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: String)
}

final class WeatherModel {
    
    // MARK: - Properties
    
    weak var delegate: WeatherModelDelegate?
    
    // MARK: - Methods
    
    func fetchWeather() {
        let jsonString =
        """
        {
            "area" : "tokyo",
            "date": "2020-04-01T12:00:00+09:00"
        }
        """
        
        do {
            let weatherJson = try YumemiWeather.fetchWeather(jsonString)
            guard let jsonData = weatherJson.data(using: .utf8) else {
                print("データ型への変換に失敗しました")
                return
            }
            guard let weather = try? JSONDecoder().decode(Weather.self, from: jsonData) else {
                print("デコードに失敗しました")
                return
            }
            delegate?.weatherModel(self, didFetchWeather: weather)
        } catch let error as YumemiWeatherError {
            switch error {
            case .invalidParameterError:
                delegate?.weatherModel(self, didOccurError: "jsonのパースに失敗しました")
            case .unknownError:
                delegate?.weatherModel(self, didOccurError: "予期しないエラーが発生しました")
            }
        } catch {
            delegate?.weatherModel(self, didOccurError: "予期しないエラーが発生しました")
        }
    }
}
