//
//  ShopSearchResultViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit

final class ShopSearchResultViewController: BaseViewController {
    private var item = ShopResponse(total: 0, items: [])
    private let resultLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let simButton = UIButton(configuration: .filled())
    private let dateButton = UIButton(configuration: .filled())
    private let ascButton = UIButton(configuration: .filled())
    private let dscButton = UIButton(configuration: .filled())
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public func reload(from title: String, to item: ShopResponse) {
        self.item = item
        print(item)
        configureNavigation(title)
        collectionView.reloadData()
    }
}

private extension ShopSearchResultViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureButton()
        configureCollectionView()
    }
    
    private func configureNavigation(_ title: String) {
        navigationItem.title = title
    }
    
    private func configureSubview() {
        view.addSubviews(resultLabel, simButton, dateButton, ascButton, dscButton, collectionView)
    }
    
    private func configureLayout() {
        resultLabel.text = "000,000,000건"
        resultLabel.snp.makeConstraints {
            $0.top.equalToSuperview(\.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(16)
        }
        
        simButton.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        dateButton.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(8)
            $0.leading.equalTo(simButton.snp.trailing).offset(8)
        }
        
        ascButton.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(8)
            $0.leading.equalTo(dateButton.snp.trailing).offset(8)
        }
        
        dscButton.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(8)
            $0.leading.equalTo(ascButton.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualToSuperview().inset(12).priority(1)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(simButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureButton() {
        simButton.setTitle("정확도", for: .normal)
        simButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateButton.setTitle("날짜순", for: .normal)
        dateButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        ascButton.setTitle("가격높은순", for: .normal)
        ascButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dscButton.setTitle("가격낮은순", for: .normal)
        dscButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

extension ShopSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShopCell.self, forCellWithReuseIdentifier: "ShopCell")
        
        let layout = UICollectionViewFlowLayout()
        let screen = UIScreen.main.bounds
        
        layout.itemSize = CGSize(width: screen.width / 2, height: screen.width / 2 + screen.width / 4)
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = .zero
        
        collectionView.collectionViewLayout = layout
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        item.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath)
        
        if let cell = cell as? ShopCell {
            let item = item.items[indexPath.item]
            
            cell.brandLabel.text = item.brand
            cell.titleLabel.text = item.title
            cell.priceLabel.text = item.lprice
        }
        
        return cell
    }
}

class ShopCell: UICollectionViewCell {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    ShopSearchResultViewController()
}
