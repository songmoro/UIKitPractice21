//
//  ShopSearchItem.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/28/25.
//

struct ShopSearchItem {
    var page: Int
    var total: Int
    var display: Int
    var items: [ShopItem]
    
    init(page: Int = 1, total: Int = 0, display: Int = 100, items: [ShopItem] = [ShopItem]()) {
        self.page = page
        self.total = total
        self.display = display
        self.items = items
    }
    
    func hasNextPage(_ item: Int) -> Bool {
        item == (items.count - 2) && total > (items.count + display)
    }
}
