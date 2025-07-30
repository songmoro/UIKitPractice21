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
        if case .failure(let error) = dataResponse.result { throw APIErrorReason.responseFailedWithAFError(error: error) }
        else if case .success(let data) = dataResponse.result {
            if !(200..<300 ~= response.statusCode) {
                guard let data else { throw APIErrorReason.responseFailedWithDataIsNil }
                guard let errorResponseType = api.errorResponseType else { throw APIErrorReason.responseFailedWithDataCantDecode }
                guard let decodedData = try? JSONDecoder().decode(errorResponseType, from: data) else { throw APIErrorReason.responseFailedWithDataDecodeFailed }
                throw APIErrorReason.responseFailedWithErrorReason(error: decodedData)
            }
            else {
                guard let data else { throw APIErrorReason.responseSuccessWithDataIsNil }
                guard let decodedData = try? JSONDecoder().decode(api.responseType,from: data) else { throw APIErrorReason.responseSuccessWithDataCantDecode }
                
                return decodedData
            }
        }
        
        throw APIErrorReason.responseFailedWithUnknownReason
    }
}
