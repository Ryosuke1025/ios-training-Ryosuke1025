//
//  WeatherModel.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/11/29.
//

import Foundation
import YumemiWeather

enum APIError: Error {
    case invalidParameter
    case unknown
}

class WeatherModel {
    // MARK: - Methods
    
    func fetchWeather(completionHandler: @escaping (Result<ResponseModel, Error>) -> Void) {
        let request = RequestModel(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        guard let requestData = encode(request: request) else {
            assertionFailure("エンコードに失敗しました")
            completionHandler(.failure(APIError.unknown))
            return
        }
        
        guard let requestString = String(data: requestData, encoding: .utf8) else { return }
        YumemiWeather.asyncFetchWeather(requestString: requestString, completionHandler: { result in
            switch result {
            case .success(let responseString):
                print(responseString)
                guard let responseData = responseString.data(using: .utf8), let response = self.decode(responseData: responseData) else {
                    assertionFailure("デコードに失敗しました")
                    completionHandler(.failure(APIError.unknown))
                    return
                }
                completionHandler(.success(response))
            case .failure(let error):
                if let error = error as? YumemiWeatherError {
                    switch error {
                    case .invalidParameterError:
                        completionHandler(.failure(APIError.invalidParameter))
                        print("デコードに失敗しました")
                    case .unknownError:
                        completionHandler(.failure(APIError.unknown))
                        print("乱数4が発生しました")
                    }
                } else {
                    completionHandler(.failure(APIError.unknown))
                }
            }
        })
    }
    
    func encode(request: RequestModel) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return try? encoder.encode(request)
    }
    
    func decode(responseData: Data) -> ResponseModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(ResponseModel.self, from: responseData)
    }
}
