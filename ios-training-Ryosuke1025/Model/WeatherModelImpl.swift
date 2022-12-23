//
//  WeatherModel.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/29.
//

import Foundation
import YumemiWeather

protocol WeatherModelDelegate: AnyObject {
    func weatherModel(_ weatherModel: WeatherModel, didFetchWeather weather: ResponseModel)
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: ShowError)
}

protocol WeatherModel {
    var delegate: WeatherModelDelegate? { get set}
    func fetchWeather()
}

enum ShowError {
    case invalidParameterError
    case unknownError
}
final class WeatherModelImpl: WeatherModel {
    
    // MARK: - Properties
    
    weak var delegate: WeatherModelDelegate?
    
    // MARK: - Methods
    
    func fetchWeather() {
        let convert = Convert()
        let request = RequestModel(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        do {
            let requestData = try convert.encode(request: request)
            guard let requestString = String(data: requestData, encoding: .utf8) else {
                assertionFailure("データ型からString型への変換に失敗しました")
                return
            }
            do {
                let responseString = try YumemiWeather.fetchWeather(requestString)
                guard let responseData = responseString.data(using: .utf8) else {
                    assertionFailure("受け取ったString型からデータ型への変換に失敗しました")
                    return
                }
                do {
                    let response = try convert.decode(responseData: responseData)
                    delegate?.weatherModel(self, didFetchWeather: response)
                } catch {
                    delegate?.weatherModel(self, didOccurError: ShowError.unknownError)
                }
                
            } catch let error as YumemiWeatherError {
                switch error {
                case .invalidParameterError:
                    delegate?.weatherModel(self, didOccurError: ShowError.invalidParameterError)
                case .unknownError:
                    delegate?.weatherModel(self, didOccurError: ShowError.unknownError)
                }
            } catch {
                delegate?.weatherModel(self, didOccurError: ShowError.unknownError)
            }
        } catch {
            delegate?.weatherModel(self, didOccurError: ShowError.unknownError)
        }
    }
}
