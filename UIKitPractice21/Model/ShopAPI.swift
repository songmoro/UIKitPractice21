//
//  ShopAPI.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

import Foundation
import Alamofire

enum ShopAPI: API {
    case search(query: String, display: Int, start: Int, sort: String = "sim")
}

extension ShopAPI {
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
