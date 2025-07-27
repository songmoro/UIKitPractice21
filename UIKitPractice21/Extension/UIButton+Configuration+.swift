//
//  UIButton+Configuration+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/27/25.
//

import UIKit

extension UIButton.Configuration {
    static func selectedFilled(_ title: String?) -> Self {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .label
        configuration.baseForegroundColor = .systemBackground
        
        return configuration
    }
    
    static func defaultFilled(_ title: String?) -> Self {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .label
        configuration.background.strokeColor = .label
        configuration.background.strokeWidth = 1
        
        return configuration
    }
}
