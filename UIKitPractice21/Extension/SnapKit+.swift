//
//  SnapKit+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

#if canImport(UIKit)
import UIKit
public typealias ConstraintView = UIView
#else
import AppKit
public typealias ConstraintView = NSView
#endif

import SnapKit

extension [ConstraintView] {
    var snp: [ConstraintViewDSL] {
        map(\.snp)
    }
}

extension [ConstraintViewDSL] {
    func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.forEach { constraintView in
            (constraintView.target as! ConstraintView).snp.makeConstraints(closure)
        }
    }
}
