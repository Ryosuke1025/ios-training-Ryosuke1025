//
//  WeatherModel.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/29.
//

import Foundation
import YumemiWeather

protocol WeatherModelDelegate: AnyObject {
    func weatherModel(_ weatherModel: WeatherModel, didFetchWeather weather: String)
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: String)
}

final class WeatherModel {
    
    // MARK: - Properties
    
    weak var delegate: WeatherModelDelegate?
    
    // MARK: - Methods
    
    func fetchWeather() {
        let area = "tokyo"
        do{
            let weather = try YumemiWeather.fetchWeatherCondition(at: area)
            delegate?.weatherModel(self, didFetchWeather: weather)
        } catch let error as YumemiWeatherError{
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
