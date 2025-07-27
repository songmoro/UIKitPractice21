//
//  ShopAPI.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

import Foundation
import Alamofire

struct ShopAPI: IsAPI {
    let baseURL: String = "https://openapi.naver.com/v1"
    let path: String
    var url: URL? {
        URL(string: baseURL + path)
    }
    let method: HTTPMethod
    let parameters: Parameters?
    let headers: HTTPHeaders? = HTTPHeaders([
        "X-Naver-Client-Id": APIKey.naverClientId,
        "X-Naver-Client-Secret": APIKey.naverClientSecret
    ])
    
    init(request: ShopRequest) {
        self.path = "/search/shop.json"
        self.method = .get
        self.parameters = [
            "query": request.query,
            "display": request.display,
            "start": request.start,
            "sort": request.sort
        ]
    }
}
