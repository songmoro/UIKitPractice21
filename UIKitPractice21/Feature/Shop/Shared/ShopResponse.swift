//
//  ShopResponse.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import RegexBuilder

struct ShopResponse: Decodable {
    let total: Int
    let items: [ShopItem]
}

struct ShopItem: Decodable {
    let title: String
    let image: String
    let brand: String
    let lprice: String
    let hprice: String
    
    let originalTitle: String
    
    enum CodingKeys: CodingKey {
        case title
        case image
        case brand
        case lprice
        case hprice
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originalTitle = try container.decode(String.self, forKey: .title) //        ?<keyword> -> Capture
        self.title = originalTitle.replacing(/<b>|<\/b>/, with: "")
        self.image = try container.decode(String.self, forKey: .image)
        let brand = try container.decode(String.self, forKey: .brand)
        self.brand = brand.isEmpty ? "브랜드 없음" : brand
        self.lprice = try container.decode(String.self, forKey: .lprice)
        self.hprice = try container.decode(String.self, forKey: .hprice)
    }
}
