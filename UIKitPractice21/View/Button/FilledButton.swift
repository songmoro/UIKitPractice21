//
//  FilledButton.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/26/25.
//

import UIKit

class FilledButton: BaseButton {
    var title: String = ""
    
     init(_ title: String) {
        super.init(frame: .zero)
        self.title = title
        
        configure()
    }
    
    private func configure() {
        configureConfiguration()
        configureLayout()
    }
    
    private func configureConfiguration() {
        configurationUpdateHandler = {
            $0.configuration = ($0.isSelected) ? .selectedFilled(self.title) : .defaultFilled(self.title)
        }
    }
    
    private func configureLayout() {
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
