//
//  ShopRecommendedViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/29/25.
//

import UIKit
import SnapKit
import Then

fileprivate enum ShopRecommendedViewControllerErrorReason: LocalizedError {
    case responseTypeIsInvalid
}

final class ShopRecommendedViewController: BaseViewController {
    private var searchText = ""
    private var searchItem = ShopSearchItem(display: 10)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .clear
        $0.register(ShopRecommendedCell.self)
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configure()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        configureCollectionView()
    }
    
    public func input(text: String) {
        searchText = text
        call()
    }
}

extension ShopRecommendedViewController {
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

extension ShopRecommendedViewController {
    private func call() {
        Task {
            do {
                let api = ShopAPI.search(query: searchText, display: searchItem.display, start: searchItem.page)
//                let api = ShopAPI.search(query: searchText, display: -1, start: searchItem.page)
//                let api = ShopAPI.search(query: searchText, display: searchItem.display, start: -1)
//                let api = ShopAPI.search(query: searchText, display: searchItem.display, start: searchItem.page)
                
                let response = try await NetworkManager.shared.caall(by: api)
                guard let response = response as? ShopResponse else { throw ShopRecommendedViewControllerErrorReason.responseTypeIsInvalid }
                self.handleResponse(response)
            }
            catch(let error) {
                print(error)
            }
        }
    }
    
    private func handleResponse(_ response: ShopResponse) {
        searchItem.total = response.total
        updateCollectionView(items: response.items)
    }
    
    private func handleError(_ error: Error) {
        showAlert(message: error.localizedDescription, defaultTitle: "재시도") { [unowned self] in
            call()
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
        searchItem.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ShopRecommendedCell.self, for: indexPath)
        let item = searchItem.items[indexPath.item]
        cell.reload(item)
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if searchItem.hasNextPage(indexPath.item) {
            searchItem.page += 1
            call()
        }
    }
    
    private func updateCollectionView(items: [ShopItem]) {
        self.searchItem.items.append(contentsOf: items)
        collectionView.reloadData()
    }
}
