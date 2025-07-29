//
//  ShopRecommendedViewController.swift
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

final class ShopRecommendedViewController: BaseViewController {
    private var searchText = ""
    private var searchItem = ShopSearchItem()
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
//                let api = ShopAPI.search(query: searchText, display: -1, start: searchItem.page, sort: button.sortBy.rawValue)
//                let api = ShopAPI.search(query: searchText, display: searchItem.display, start: -1, sort: button.sortBy.rawValue)
//                let api = ShopAPI.search(query: searchText, display: searchItem.display, start: searchItem.page, sort: "button.sortBy.rawValue")
                
                let response = try await NetworkManager.shared.call(by: api)
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
