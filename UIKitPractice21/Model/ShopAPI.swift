//
//  ShopAPI.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

import Foundation
import Alamofire

fileprivate enum ShopAPIErrorReason: LocalizedError {
    case urlIsInvalid
    case responseIsNil
    case requestFailed(statusCode: Int)
    case dataIsNil
    case decodeFailed
    
    var errorDescription: String? {
        switch self {
        case .urlIsInvalid:
            "URL 생성 실패"
        case .responseIsNil:
            "네트워크 응답 없음"
        case .requestFailed(let statusCode):
            "네트워크 요청 실패(statusCode: \(statusCode))"
        case .dataIsNil:
            "네트워크 응답 데이터가 없음"
        case .decodeFailed:
            "네트워크 응답 데이터 디코딩 실패"
        }
    }
}

enum ShopAPI {
    case search(query: String, display: Int, start: Int, sort: String)
}

extension ShopAPI: URLRequestConvertible {
    private var baseURL: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1") else {
            fatalError("URL is invalid")
        }
        return url
    }
    
    private var path: String {
        switch self {
        case .search:
            return "/search/shop"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    private var headers: HTTPHeaders {
        HTTPHeaders([
            "X-Naver-Client-Id": APIKey.naverClientId,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ])
    }
    
    private var parameters: Parameters? {
        switch self {
        case .search(let query, let display, let start, let sort):
            return ["query": query, "display": display, "start": start, "sort": sort]
        }
    }
    
    internal func call(completionHandler: @escaping (Result<ShopResponse, Error>) -> Void) {
        do {
            guard let request = try? self.asURLRequest() else {
                throw ShopAPIErrorReason.urlIsInvalid
            }
            
            AF.request(request)
                .response {
                    do {
                        guard let response = $0.response else {
                            throw ShopAPIErrorReason.responseIsNil
                        }
                        guard 200..<300 ~= response.statusCode else {
                            throw ShopAPIErrorReason.requestFailed(statusCode: response.statusCode)
                        }
                        
                        if case .failure(let error) = $0.result {
                            throw error
                        }
                        else if case let .success(data) = $0.result {
                            guard let data else {
                                throw ShopAPIErrorReason.dataIsNil
                            }
                            guard let response = try? JSONDecoder().decode(ShopResponse.self, from: data) else {
                                throw ShopAPIErrorReason.decodeFailed
                            }
                            
                            completionHandler(.success(response))
                        }
                        else {
                            throw NSError(domain: "Unknown result error", code: 1000)
                        }
                    }
                    catch(let error) {
                        completionHandler(.failure(error))
                    }
                }
        }
        catch(let error) {
            completionHandler(.failure(error))
        }
    }
    
    internal func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest: URLRequest = {
            switch self {
            case .search:
                return URLRequest(url: url.appendingPathComponent(path, conformingTo: .json))
            }
        }()
        
        urlRequest.method = method
        urlRequest.headers = headers
        
        if let parameters {
            switch self {
            case .search:
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            }
        }
        
        return urlRequest
    }
}
