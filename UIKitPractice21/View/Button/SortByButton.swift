//
//  SortByButton.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

class SortByButton: FilledButton {
    var sortBy = SortBy.sim
    
    init(sortBy: SortBy, title: String) {
        self.sortBy = sortBy
        super.init(title)
    }
}
