//
//  NetworkManager.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func call<T: API, R: Decodable, E: Decodable>(by api: T, of type: R.Type = R.self, or errorType: E.Type = E.self) async throws -> R {
        let dataResponse = try await AF.request(api)
        let response = try dataResponse.response.unwrapped()
        let data = try dataResponse.result.get()
        
        if 200..<300 ~= response.statusCode {
            let response: R = try CustomJSONDecoder().decode(type: type.self, from: data)
            return response
        }
        else {
            let errorResponse: E = try CustomJSONDecoder().decode(type: errorType.self, from: data)
            throw APIErrorReason.responseFailedWithError(errorResponse: errorResponse)
        }
    }
    
    func call<T: API, R: Decodable>(by api: T, of type: R.Type = R.self) async throws -> R {
        let dataResponse = try await AF.request(api)
        let response = try dataResponse.response.unwrapped()
        let data = try dataResponse.result.get()
        
        if 200..<300 ~= response.statusCode {
            let response: R = try CustomJSONDecoder().decode(type: type.self, from: data)
            return response
        }
        else {
            throw APIErrorReason.responseFailedWithStatusCode(statusCode: response.statusCode)
        }
    }
}
