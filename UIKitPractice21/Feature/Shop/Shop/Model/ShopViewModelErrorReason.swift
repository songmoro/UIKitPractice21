//
//  ShopViewModelErrorReason.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

import Foundation

enum ShopViewModelErrorReason: LocalizedError {
    case textIsNil
    case textIsLowerThanTwo
    
    var errorDescription: String? {
        switch self {
        case .textIsNil: "검색 값이 비어있음"
        case .textIsLowerThanTwo: "검색 값이 두 글자 이하"
        }
    }
}
