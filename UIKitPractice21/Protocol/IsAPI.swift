//
//  IsAPI.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

import Foundation
import Alamofire

protocol IsAPI {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
}

enum E: Error {
    case a
}

extension IsAPI {
    func call(response: @escaping (Result<Data?, Error>) -> (Void)) {
        guard let url else {
            response(.failure(E.a))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers {
            request.headers = headers
        }
        
        if let parameters {
            do {
                request = try URLEncoding(destination: .queryString).encode(request, with: parameters)
            }
            catch(let error) {
                response(.failure(error))
            }
        }
        
        AF.request(request)
            .response {
                switch $0.result {
                case .success(let data):
                    response(.success(data))
                case .failure(let error):
                    response(.failure(error))
                }
            }
    }
}
