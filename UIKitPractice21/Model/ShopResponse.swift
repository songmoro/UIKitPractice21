//
//  ShopResponse.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//


struct ShopResponse: Decodable {
    let total: Int
    let items: [ShopItem]
}