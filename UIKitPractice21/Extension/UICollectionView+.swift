//
//  UICollectionView+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit

extension UICollectionView {
    typealias Cell = BaseCollectionViewCell
    
    func register<T: Cell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: Cell>(_ cellClass: T.Type = T.self, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}
