//
//  Weather.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/12/02.
//

import Foundation

struct Weather: Codable {
    let maxTemperature: Int
    let date: String
    let minTemperature: Int
    let weatherCondition: String
    
    enum CodingKeys: CodingKey {
        case maxTemperature
        case date
        case minTemperature
        case weatherCondition
    }
}
