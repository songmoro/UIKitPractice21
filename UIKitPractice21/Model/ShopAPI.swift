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
    case requestFailed
    case dataIsNil
    case decodeFailed
    
    var errorDescription: String? {
        switch self {
        case .urlIsInvalid:
            "URL 생성 실패"
        case .requestFailed:
            "네트워크 요청 실패"
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
        guard let request = try? self.asURLRequest() else {
            completionHandler(.failure(ShopAPIErrorReason.urlIsInvalid))
            return
        }
        
        AF.request(request)
            .response {
                guard $0.response != nil, 200..<300 ~= $0.response!.statusCode else {
                    completionHandler(.failure(ShopAPIErrorReason.requestFailed))
                    return
                }
                
                switch $0.result {
                case .success(let data):
                    if let data {
                        guard let response = try? JSONDecoder().decode(ShopResponse.self, from: data) else {
                            completionHandler(.failure(ShopAPIErrorReason.decodeFailed))
                            return
                        }
                        completionHandler(.success(response))
                    }
                    else {
                        completionHandler(.failure(ShopAPIErrorReason.dataIsNil))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
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
