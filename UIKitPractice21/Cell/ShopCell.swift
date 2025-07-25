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
    let heartButton = UIButton()
    let brandLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureDesign()
    }
    
    private func configureSubview() {
        addSubviews(imageView, heartButton, brandLabel, titleLabel, priceLabel)
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalToSuperview(\.snp.width).inset(8)
        }
        
        heartButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(imageView).inset(8)
            $0.size.equalTo(imageView).multipliedBy(0.2)
        }
        
        brandLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(brandLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configureDesign() {
        imageView.layer.cornerRadius = 24
        imageView.backgroundColor = .red
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        heartButton.imageView!.tintColor = .systemBackground
        heartButton.backgroundColor = .label
        heartButton.layer.cornerRadius = heartButton.bounds.width / 2
        heartButton.layer.masksToBounds = true
        brandLabel.font = .systemFont(ofSize: 13)
        titleLabel.font = .systemFont(ofSize: 14)
        priceLabel.font = .systemFont(ofSize: 17)
        titleLabel.numberOfLines = 2
    }
}
