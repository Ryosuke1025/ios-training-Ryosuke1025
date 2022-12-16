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
    func weatherModel(_ weatherModel: WeatherModel, didOccurError error: String)
}

protocol WeatherModel {
    var delegate: WeatherModelDelegate? { get set}
    func fetchWeather()
}

class WeatherModelImpl: WeatherModel {
    
    // MARK: - Properties
    
    weak var delegate: WeatherModelDelegate?
    
    // MARK: - Methods
    
    func fetchWeather() {
        let request = RequestModel(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        let requestData = encode(request: request)
        guard let requestString = String(data: requestData, encoding: .utf8) else {
            assertionFailure("データ型からString型への変換に失敗しました")
            return
        }
        YumemiWeather.asyncFetchWeather(requestString: requestString, completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseString):
                guard let responseData = responseString.data(using: .utf8) else {
                    assertionFailure("受け取ったString型からデータ型への変換に失敗しました")
                    return
                }
                let response = self.decode(responseData: responseData)
                
                self.delegate?.weatherModel(self, didFetchWeather: response)
            case .failure(let error):
                if let error = error as? YumemiWeatherError {
                    switch error {
                    case .invalidParameterError:
                        self.delegate?.weatherModel(self, didOccurError: "jsonのパースに失敗しました")
                    case .unknownError:
                        self.delegate?.weatherModel(self, didOccurError: "予期しないエラーが発生しました")
                    }
                } else {
                    self.delegate?.weatherModel(self, didOccurError: "予期しないエラーが発生しました")
                }
            }
        })
    }
    
    func encode(request: RequestModel) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        guard let requestData = try? encoder.encode(request) else {
            fatalError("requestからJSONデータへのエンコードに失敗しました")
        }
        return requestData
    }
    
    func decode(responseData: Data) -> ResponseModel {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let response = try? decoder.decode(ResponseModel.self, from: responseData) else {
            fatalError("ResponseModelへのデコードに失敗しました")
        }
        return response
    }
}
