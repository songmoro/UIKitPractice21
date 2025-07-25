//
//  ShopSearchResultViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit

final class ShopSearchResultViewController: BaseViewController {
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
}

private extension ShopSearchResultViewController {
    private func configure() {
        configureNavigation()
        configureSubview()
        configureLayout()
        configureButton()
        configureCollectionView()
    }
    
    private func configureNavigation() {
        navigationItem.title = "캠핑카"
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
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

#Preview {
    ShopSearchResultViewController()
}
