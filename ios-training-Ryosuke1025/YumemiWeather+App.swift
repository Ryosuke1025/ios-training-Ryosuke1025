//
//  YumemiWeather+App.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/12/16.
//

import Foundation
import YumemiWeather

extension YumemiWeather {
    public static func asyncFetchWeather(requestString: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().async(execute: {
            do {
                let responseString = try self.syncFetchWeather(requestString)
                completionHandler(.success(responseString))
            } catch {
                completionHandler(.failure(error))
            }
        })
    }
}
