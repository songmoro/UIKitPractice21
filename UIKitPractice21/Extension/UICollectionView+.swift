//
//  UICollectionView+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: BaseCollectionViewCell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell(_ cellClass: BaseCollectionViewCell.Type, for indexPath: IndexPath) -> BaseCollectionViewCell {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as! BaseCollectionViewCell
    }
}
