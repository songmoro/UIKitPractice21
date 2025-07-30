//
//  API.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/30/25.
//

import Foundation
import Alamofire

enum APIErrorReason: Error {
    case responseFailedWithError(errorResponse: Decodable)
    case responseFailedWithStatusCode(statusCode: Int)
    case responseFailedWithUnknownReason
}

protocol API: URLRequestConvertible {
    
}
