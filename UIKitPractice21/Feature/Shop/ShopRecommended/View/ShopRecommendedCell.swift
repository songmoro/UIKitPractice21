//
//  ShopRecommendedCell.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class ShopRecommendedCell: BaseCollectionViewCell {
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
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
    }
    
    private func configureSubview() {
        contentView.addSubview(imageView)
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
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
    }
}
