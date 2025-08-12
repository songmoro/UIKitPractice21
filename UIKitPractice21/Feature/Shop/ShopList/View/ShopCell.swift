//
//  ShopCell.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class ShopCell: BaseCollectionViewCell {
    private var model: ShopItem? {
        didSet {
            guard let model else { return }
            update(model)
        }
    }
    
    private let imageView = UIImageView().then {
        $0.kf.indicatorType = .activity
        $0.backgroundColor = .systemGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }
    private let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.backgroundColor = .label
    }
    private let brandLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemGray
    }
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.numberOfLines = 2
    }
    private let priceLabel = UILabel()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}

// MARK: Configure
extension ShopCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureHeartButton()
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
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(imageView.snp.bottom).offset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(brandLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    
    private func configureHeartButton() {
        heartButton.do {
            $0.imageView!.tintColor = .systemBackground
            $0.layer.cornerRadius = $0.bounds.width / 2
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
        }
    }
    
    @objc private func heartButtonClicked(_ sender: UIButton) {
        heartButton.isSelected.toggle()
    }
}

// MARK: Update
extension ShopCell {
    public func reload(_ item: ShopItem) {
        model = item
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
    
    private func update(_ model: ShopItem) {
        imageView.do {
            let url = URL(string: model.image)!
            let processor = DownsamplingImageProcessor(size: CGSize(width: $0.bounds.width, height: $0.bounds.height))
            $0.kf.setImage(with: url, options: [.processor(processor)])
        }
        
        brandLabel.text = model.brand.isEmpty ? "브랜드 없음" : model.brand
        titleLabel.text = model.title
        
        priceLabel.do {
            let price = Int(model.lprice) ?? 0
            let attributedText = NSAttributedString(string: price.formatted(), attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
            $0.attributedText = attributedText
        }
    }
}
