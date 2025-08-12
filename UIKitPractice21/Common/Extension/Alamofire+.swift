//
//  Alamofire+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/30/25.
//

import Foundation
import Alamofire

extension Alamofire.Session {
    func request(_ convertible: any URLRequestConvertible) async throws -> AFDataResponse<Data?> {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(convertible)
                .response {
                    switch $0.result {
                    case .success:
                        continuation.resume(returning: $0)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
