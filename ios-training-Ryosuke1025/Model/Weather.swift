//
//  Weather.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/12/02.
//

import Foundation

struct Weather: Codable {
    let max_temperature: Int
    let date: String
    let min_temperature: Int
    let weather_condition: String
}
