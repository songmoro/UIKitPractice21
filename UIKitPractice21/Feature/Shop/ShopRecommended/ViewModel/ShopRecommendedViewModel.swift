//
//  ShopRecommendedViewModel.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

final class ShopRecommendedViewModel {
    let keyword: String
    var searchItem = ShopSearchItem(display: 10)
    
    init(keyword: String) {
        self.keyword = keyword
    }
}
