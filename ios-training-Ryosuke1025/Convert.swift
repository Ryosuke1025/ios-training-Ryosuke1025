//
//  Convert.swift
//  ios-training-Ryosuke1025
//
//  Created by 須崎 良祐 on 2022/12/23.
//
import UIKit

enum ConvertError: Error {
    case encode
    case decode
}

class Convert {
    func encode(request: RequestModel) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        guard let requestData = try? encoder.encode(request) else {
            throw ConvertError.encode
        }
        return requestData
    }
    
    func decode(responseData: Data) throws -> ResponseModel {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let response = try? decoder.decode(ResponseModel.self, from: responseData) else {
            throw ConvertError.decode
        }
        return response
    }
}
