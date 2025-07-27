//
//  ShopSearchViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit

final class ShopSearchViewController: BaseViewController {
    private var searchText = ""
    
    private let resultLabel = UILabel()
    
    private var selected = SortByButton(sortBy: .none, title: "")
    private let simButton = SortByButton(sortBy: .sim, title: "정확도")
    private let dateButton = SortByButton(sortBy: .date, title: "날짜순")
    private let ascButton = SortByButton(sortBy: .asc, title: "가격높은순")
    private let dscButton = SortByButton(sortBy: .dsc, title: "가격낮은순")
    
    private var item = ShopResponse(total: 0, items: [])
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: Configure
private extension ShopSearchViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureButton()
        configureCollectionView()
    }
    
    private func configureSubview() {
        view.addSubviews(resultLabel, simButton, dateButton, ascButton, dscButton, collectionView)
    }
    
    private func configureLayout() {
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
            $0.trailing.greaterThanOrEqualToSuperview().inset(12).priority(.low)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(simButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureButton() {
        [simButton, dateButton, ascButton, dscButton].forEach {
            $0.addTarget(self, action: #selector(sortByButtonClicked), for: .touchUpInside)
        }
        
        sortByButtonClicked(simButton)
    }
}

// MARK: Update
extension ShopSearchViewController {
    public func input(text: String) {
        self.searchText = text
        updateNavigation(text)
    }
    
    private func updateNavigation(_ title: String) {
        navigationItem.title = title
    }
    
    private func updateResultLabel(_ result: Int) {
        let attributedText = NSAttributedString(string: "\(result.formatted()) 개의 검색 결과", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.systemGreen])
        resultLabel.attributedText = attributedText
    }
    
    @objc private func sortByButtonClicked(_ sender: SortByButton) {
        updateSortBy(sender)
        call()
    }
    
    private func updateSortBy(_ button: SortByButton) {
        selected.isSelected = false
        selected = button
        selected.isSelected = true
    }
    
    private func call() {
        let request = ShopRequest(query: searchText, display: 100, sort: String(describing: selected.sortBy))
        ShopAPI(request: request).call {
            switch $0 {
            case .success(let data):
                let response = try! JSONDecoder().decode(ShopResponse.self, from: data!)
                self.updateCollectionView(item: response)
            case .failure(let error):
                break
            }
        }
    }
}

// MARK: CollectionView
extension ShopSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShopCell.self)
        
        let layout = UICollectionViewFlowLayout()
        let screen = UIScreen.main.bounds
        
        layout.itemSize = CGSize(width: screen.width / 2, height: screen.width / 2 + screen.width / 6)
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = .zero
        
        collectionView.collectionViewLayout = layout
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        item.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShopCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = item.items[indexPath.item]
        cell.reload(item)
        
        return cell
    }
    
    private func updateCollectionView(item: ShopResponse) {
        self.item = item
        collectionView.reloadData()
    }
}

#if DEBUG
#Preview {
    ShopSearchViewController()
}
#endif
