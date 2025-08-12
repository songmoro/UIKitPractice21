//
//  ShopSearchViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import UIKit
import SnapKit
import Then

final class ShopSearchViewController: BaseViewController<ShopSearchViewModel> {
    private let collectionViewController: ShopCollectionViewController
    private let recommendedViewController: ShopRecommendedViewController
    
    override init(viewModel: ShopSearchViewModel) {
        let shopCollectionVM = ShopCollectionViewModel(keyword: viewModel.keyword)
        let shopRecommendedVM = ShopRecommendedViewModel(keyword: viewModel.keyword)
        
        self.collectionViewController = ShopCollectionViewController(viewModel: shopCollectionVM)
        self.recommendedViewController = ShopRecommendedViewController(viewModel: shopRecommendedVM)
        
        super.init(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension ShopSearchViewController {
    private func configure() {
        configureSubview()
        configureChild()
        configureLayout()
        configureView()
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
    
    private func configureView() {
        navigationItem.title = viewModel.keyword
    }
}
