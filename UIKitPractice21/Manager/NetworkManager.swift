//
//  NetworkManager.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import Foundation
import Alamofire

fileprivate enum ShopAPIErrorReason: LocalizedError {
    case urlIsInvalid
    case responseIsNil
    case requestFailedWithError(statusCode: Int, error: AFError)
    case requestFailedWithShopError(statusCode: Int, error: ShopError)
    case requestFailedAndShopErrorDataIsNil(statusCode: Int)
    case requestFailedAndFailedShopErrorDecode(statusCode: Int)
    case requestSuceessButDataIsNil(statusCode: Int)
    case requestSuccessButHasError(statusCode: Int, error: AFError)
    case requestSuceessButDecodeFailed(statusCode: Int, data: Data)
    
    var errorDescription: String? {
        switch self {
        case .urlIsInvalid:
            "URL이 올바르지 않음"
        case .responseIsNil:
            "네트워크 응답 없음"
        case .requestFailedWithError(let statusCode, let error):
            "네트워크 응답 실패(code: \(statusCode), error: \(error.errorDescription ?? "에러 코드 없음"))"
        case .requestFailedWithShopError(let statusCode, let error):
            "네트워크 응답 실패(code: \(statusCode), errorCode: \(error.errorCode), errorMessage:\(error.errorMessage))"
        case .requestFailedAndShopErrorDataIsNil(let statusCode):
            "네트워크 응답 실패(code: \(statusCode))"
        case .requestFailedAndFailedShopErrorDecode(let statusCode):
            "네트워크 응답 실패(code: \(statusCode))"
        case .requestSuceessButDataIsNil(let statusCode):
            "네트워크 응답 실패(code: \(statusCode))"
        case .requestSuccessButHasError(let statusCode, let error):
            "네트워크 응답 실패(code: \(statusCode), error: \(error.localizedDescription)"
        case .requestSuceessButDecodeFailed(let statusCode, let data):
            "네트워크 응답 실패(code: \(statusCode), data: \(String(data: data, encoding: .utf8) ?? "데이터 인코딩 실패")"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    internal func call(by api: ShopAPI) async throws -> ShopResponse {
        try await withCheckedThrowingContinuation { continuation in
            guard let urlRequest = api.urlRequest else { return continuation.resume(throwing: ShopAPIErrorReason.urlIsInvalid) }
            
            AF.request(urlRequest)
                .response {
                    guard let response = $0.response else { return continuation.resume(throwing: ShopAPIErrorReason.responseIsNil) }
                    guard 200..<300 ~= response.statusCode else {
                        switch $0.result {
                        case .success(let data):
                            guard let data else { return continuation.resume(throwing: ShopAPIErrorReason.requestFailedAndShopErrorDataIsNil(statusCode: response.statusCode)) }
                            guard let result = try? JSONDecoder().decode(ShopError.self, from: data) else { return continuation.resume(throwing: ShopAPIErrorReason.requestFailedAndFailedShopErrorDecode(statusCode: response.statusCode)) }
                            return continuation.resume(throwing: ShopAPIErrorReason.requestFailedWithShopError(statusCode: response.statusCode, error: result))
                        case .failure(let error):
                            return continuation.resume(throwing: ShopAPIErrorReason.requestFailedWithError(statusCode: response.statusCode, error: error))
                        }
                    }
                    
                    switch $0.result {
                    case .success(let data):
                        guard let data else { return continuation.resume(throwing: ShopAPIErrorReason.requestSuceessButDataIsNil(statusCode: response.statusCode)) }
                        guard let result = try? JSONDecoder().decode(ShopResponse.self, from: data) else { return continuation.resume(throwing: ShopAPIErrorReason.requestSuceessButDecodeFailed(statusCode: response.statusCode, data: data)) }
                        return continuation.resume(returning: result)
                    case .failure(let error):
                        return continuation.resume(throwing: ShopAPIErrorReason.requestSuccessButHasError(statusCode: response.statusCode, error: error))
                    }
                }
        }
    }
}
