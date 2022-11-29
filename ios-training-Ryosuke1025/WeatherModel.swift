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
}

final class WeatherModel {
    var delegate: WeatherModelDelegate?
    
    func fetchWeather() {
        let weather = YumemiWeather.fetchWeatherCondition()
        delegate?.weatherModel(self, didFetchWeather: weather)
    }
}
