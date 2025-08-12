//
//  CustomJSONDecoder.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/30/25.
//

import Foundation

enum CustomJSONDecoderErrorReason: Error {
    case dataIsNil
}

final class CustomJSONDecoder {
    func decode<T: Decodable>(type: T.Type = T.self, from data: Data?) throws -> T {
        guard let data else { throw CustomJSONDecoderErrorReason.dataIsNil }
        return try JSONDecoder().decode(type.self, from: data)
    }
}
