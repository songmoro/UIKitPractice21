//
//  ShopRequest.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

struct ShopRequest {
    let query: String
    let display: Int
    let start: Int
    let sort: String
    
    init(query: String, display: Int = 10, start: Int = 1, sort: String = "sim") {
        self.query = query
        self.display = display
        self.start = start
        self.sort = sort
    }
}
