//
//  ShopCell.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit

class ShopCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    let brandLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        
        addSubviews(imageView, brandLabel, titleLabel, priceLabel)
        
        imageView.backgroundColor = .red
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.size.equalToSuperview(\.snp.width)
        }
        
        brandLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(brandLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
