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
    case requestFailedWithShopError(statusCode: Int, error: ShopErrorResponse)
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

protocol API: URLRequestConvertible {
    var responseType: Decodable.Type { get }
    var errorResponseType: Decodable.Type? { get }
}

enum a: API {
    var responseType: Decodable.Type {
        ShopResponse.self
    }
    
    var errorResponseType: Decodable.Type? {
        nil
    }
    
    func asURLRequest() throws -> URLRequest {
        URLRequest(url: URL(string: "")!)
    }
    
    
}

enum APIErrorReason: LocalizedError {
    case urlIsInvalid
    case responseIsNil
    case responseFailedWithDataIsNil
    case responseFailedWithDataCantDecode
    case responseFailedWithDataDecodeFailed
    case responseFailedWithErrorReason(error: Decodable)
    case responseFailedWithAFError(error: AFError)
    case responseSuccessWithDataIsNil
    case responseSuccessWithDataCantDecode
    case responseFailedWithUnknownReason
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func afRequest(urlRequest: URLRequest) async -> AFDataResponse<Data?> {
        await withCheckedContinuation { continuation in
            AF.request(urlRequest)
                .response {
                    continuation.resume(returning: $0)
                }
        }
    }
    
    func caall<T: API>(by api: T) async throws -> Decodable {
        guard let urlRequest = api.urlRequest else { throw APIErrorReason.urlIsInvalid }
        let dataResponse = await afRequest(urlRequest: urlRequest)
        guard let response = dataResponse.response else { throw APIErrorReason.responseIsNil }
        
        // MARK: v4
//        switch dataResponse.result {
//        case .success(let data):
//            guard let data else { throw APIErrorReason.responseSuccessWithDataIsNil }
//            if let errorResponseType = api.errorResponseType {
//                if let errorResponse = try? JSONDecoder().decode(errorResponseType, from: data) {
//                    throw APIErrorReason.responseFailedWithErrorReason(error: errorResponse)
//                }
//                else {
//                    throw APIErrorReason.responseFailedWithDataDecodeFailed
//                }
//            }
//            else if let decodedData = try? JSONDecoder().decode(api.responseType,from: data) {
//                return decodedData
//            }
//            else {
//                throw APIErrorReason.responseSuccessWithDataCantDecode
//            }
//        case .failure(let error):
//            throw APIErrorReason.responseFailedWithAFError(error: error)
//        }
        
        
        // MARK: v3
        switch (response.statusCode, dataResponse.result) {
        case (_, .failure(let error)):
            throw APIErrorReason.responseFailedWithAFError(error: error)
        case (..<200, .success(let data)), (300..., .success(let data)):
            guard let data else { throw APIErrorReason.responseFailedWithDataIsNil }
            guard let errorResponseType = api.errorResponseType else { throw APIErrorReason.responseFailedWithDataCantDecode }
            guard let decodedData = try? JSONDecoder().decode(errorResponseType, from: data) else { throw APIErrorReason.responseFailedWithDataDecodeFailed }
            throw APIErrorReason.responseFailedWithErrorReason(error: decodedData)
            
        case (_, .success(let data)):
            guard let data else { throw APIErrorReason.responseSuccessWithDataIsNil }
            guard let decodedData = try? JSONDecoder().decode(api.responseType,from: data) else { throw APIErrorReason.responseSuccessWithDataCantDecode }
            
            return decodedData
        }
        
//        throw APIErrorReason.responseFailedWithUnknownReason
    }
    
    private func decode<T: Decodable>(of type: T.Type = T.self, data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(type, from: data) else { throw APIErrorReason.responseFailedWithDataDecodeFailed }
        return decodedData
    }
    
    // MARK: v2
    internal func call<T>(by api: T) async throws -> Decodable where T: API {
        try await withCheckedThrowingContinuation { continuation in
            guard let urlRequest = api.urlRequest else { return continuation.resume(throwing: APIErrorReason.urlIsInvalid) }
            
            AF.request(urlRequest)
                .response {
                    guard let response = $0.response else { return continuation.resume(throwing: APIErrorReason.responseIsNil) }
                    guard 200..<300 ~= response.statusCode else {
                        switch $0.result {
                        case .success(let data):
                            guard let data else { return continuation.resume(throwing: APIErrorReason.responseFailedWithDataIsNil) }
                            guard let errorResponseType = api.errorResponseType else { return continuation.resume(throwing: APIErrorReason.responseFailedWithDataCantDecode) }
                            guard let errorResponse = try? JSONDecoder().decode(errorResponseType, from: data) else { return continuation.resume(throwing: APIErrorReason.responseFailedWithDataDecodeFailed) }
                            return continuation.resume(throwing: APIErrorReason.responseFailedWithErrorReason(error: errorResponse))
                        case .failure(let error):
                            return continuation.resume(throwing: error)
                        }
                    }
                    
                    switch $0.result {
                    case .success(let data):
                        guard let data else { return continuation.resume(throwing: APIErrorReason.responseSuccessWithDataIsNil) }
                        guard let response = try? JSONDecoder().decode(api.responseType, from: data) else { return continuation.resume(throwing: APIErrorReason.responseSuccessWithDataCantDecode) }
                        return continuation.resume(returning: response)
                    case .failure(let error):
                        return continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // MARK: v1
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
                            guard let result = try? JSONDecoder().decode(ShopErrorResponse.self, from: data) else { return continuation.resume(throwing: ShopAPIErrorReason.requestFailedAndFailedShopErrorDecode(statusCode: response.statusCode)) }
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
