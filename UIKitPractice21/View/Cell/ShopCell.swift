//
//  ShopCell.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import Kingfisher
import SnapKit

final class ShopCell: BaseCollectionViewCell {
    private var model: ShopItem? {
        didSet {
            guard let model else { return }
            update(model)
        }
    }
    
    private let imageView = UIImageView()
    private let heartButton = UIButton()
    private let brandLabel = UILabel()
    private let titleLabel = UILabel()
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
        
        [brandLabel, titleLabel, priceLabel].snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        brandLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(brandLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    
    private func configureDesign() {
        imageView.kf.indicatorType = .activity
        imageView.backgroundColor = .systemGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        heartButton.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
        heartButton.imageView!.tintColor = .systemBackground
        heartButton.backgroundColor = .label
        heartButton.layer.cornerRadius = heartButton.bounds.width / 2
        heartButton.layer.masksToBounds = true
        
        brandLabel.font = .systemFont(ofSize: 12)
        brandLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.numberOfLines = 2
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
        let url = URL(string: model.image)!
        let processor = DownsamplingImageProcessor(size: CGSize(width: imageView.bounds.width, height: imageView.bounds.height))
        imageView.kf.setImage(with: url, options: [.processor(processor)])
        
        brandLabel.text = model.brand.isEmpty ? "브랜드 없음" : model.brand
        titleLabel.text = model.title
        
        let price = Int(model.lprice) ?? 0
        let attributedText = NSAttributedString(string: price.formatted(), attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        priceLabel.attributedText = attributedText
    }
}

#if DEBUG
#Preview {
    let item = ShopItem(title: "스타리아 2층캠핑카", image: "https://shopping-phinf.pstatic.net/main_8505202/85052026934.2.jpg", brand: "월드캠핑카", lprice: "", hprice: "19000000")
    let cell = ShopCell()
    cell.reload(item)
    
    return cell
}
#endif
