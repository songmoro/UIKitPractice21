//
//  ShopSearchViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import UIKit
import SnapKit
import Then

class ShopSearchViewController: BaseViewController {
    var collectionViewController = ShopCollectionViewController()
    var recommendedViewController = ShopRecommendedViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public func input(text: String) {
        collectionViewController.input(text: text)
        recommendedViewController.input(text: text)
    }
}

extension ShopSearchViewController {
    private func configure() {
        configureSubview()
        configureChild()
        configureLayout()
    }
    
    private func configureSubview() {
        view.addSubviews(collectionViewController.view, recommendedViewController.view)
    }
    
    private func configureChild() {
        addChild(collectionViewController)
        addChild(recommendedViewController)
    }
    
    private func configureLayout() {
        collectionViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview(\.safeAreaLayoutGuide)
        }
        recommendedViewController.view.snp.makeConstraints {
            let screen = UIScreen.main.bounds
            
            $0.height.equalTo(screen.height / 6)
            $0.bottom.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
}
