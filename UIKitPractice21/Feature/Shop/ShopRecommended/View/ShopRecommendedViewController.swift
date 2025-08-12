//
//  ShopRecommendedViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import UIKit
import SnapKit
import Then

final class ShopRecommendedViewController: BaseViewController<ShopRecommendedViewModel> {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .clear
        $0.register(ShopRecommendedCell.self)
    }
    
    override init(viewModel: ShopRecommendedViewModel) {
        super.init(viewModel: viewModel)
        bind()
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configure()
        
        viewModel.inputAction = .call
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        configureCollectionView()
    }
}

extension ShopRecommendedViewController {
    private func bind() {
        viewModel.$searchItem.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func handleError(_ error: Error) {
        showAlert(message: error.localizedDescription, defaultTitle: "재시도") { [unowned self] in
//            viewModel.inputAction = .call
        }
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
    }
    
    private func configureSubview() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ShopRecommendedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout().then {
            let bounds = view.bounds
            
            $0.itemSize = CGSize(width: bounds.height, height: bounds.height)
            $0.minimumInteritemSpacing = 8
            $0.sectionInset = .zero
            $0.scrollDirection = .horizontal
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.collectionViewLayout = layout
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchItem.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ShopRecommendedCell.self, for: indexPath)
        let item = viewModel.searchItem.items[indexPath.item]
        cell.reload(item)
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.inputAction = .nextPage(itemIndex: indexPath.item)
    }
}
