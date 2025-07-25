//
//  UIView+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
