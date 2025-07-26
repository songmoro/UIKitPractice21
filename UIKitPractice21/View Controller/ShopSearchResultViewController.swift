//
//  ShopSearchResultViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit

fileprivate enum SortBy {
    case none, sim, date, asc, dsc
}

final class ShopSearchResultViewController: BaseViewController {
    private var item = ShopResponse(total: 0, items: [])
    private var sortBy = (SortBy.none, UIButton()) {
        didSet {
            
        }
    }
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

// MARK: Configure
private extension ShopSearchResultViewController {
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
        simButton.setTitle("정확도", for: .selected)
        simButton.setTitleColor(.label, for: .normal)
        simButton.setTitleColor(.systemBackground, for: .selected)
        simButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        simButton.addTarget(self, action: #selector(sortByButtonClicked), for: .touchUpInside)
        
        dateButton.setTitle("날짜순", for: .normal)
        dateButton.setTitle("날짜순", for: .selected)
        dateButton.setTitleColor(.label, for: .normal)
        dateButton.setTitleColor(.systemBackground, for: .selected)
        dateButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateButton.addTarget(self, action: #selector(sortByButtonClicked), for: .touchUpInside)
        
        ascButton.setTitle("가격높은순", for: .normal)
        ascButton.setTitle("가격높은순", for: .selected)
        ascButton.setTitleColor(.label, for: .normal)
        ascButton.setTitleColor(.systemBackground, for: .selected)
        ascButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        ascButton.addTarget(self, action: #selector(sortByButtonClicked), for: .touchUpInside)
        
        dscButton.setTitle("가격낮은순", for: .normal)
        dscButton.setTitle("가격낮은순", for: .selected)
        dscButton.setTitleColor(.label, for: .normal)
        dscButton.setTitleColor(.systemBackground, for: .selected)
//        dscButton.backgroundColor = .cl
        dscButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dscButton.addTarget(self, action: #selector(sortByButtonClicked), for: .touchUpInside)
        
        sortByButtonClicked(simButton)
    }
}

// MARK: Update
extension ShopSearchResultViewController {
    public func reload(from title: String, to item: ShopResponse) {
        self.item = item
        print(item)
        updateNavigation(title)
        updateResultLabel(item.total)
        collectionView.reloadData()
    }
    
    private func updateNavigation(_ title: String) {
        navigationItem.title = title
    }
    
    private func updateResultLabel(_ result: Int) {
        let attributedText = NSAttributedString(string: "\(result.formatted()) 개의 검색 결과", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.systemGreen])
        resultLabel.attributedText = attributedText
    }
    
    @objc private func sortByButtonClicked(_ sender: UIButton) {
        updateSortBy(sender)
    }
    
    private func updateSortBy(_ button: UIButton) {
        // TODO: 버튼 커스텀
        [simButton, dateButton, ascButton, dscButton].forEach {
            $0.isSelected = false
        }
        
        button.isSelected = true
        sortBy.1 = button
        
        switch button {
        case simButton:
            sortBy.0 = .sim
        case dateButton:
            sortBy.0 = .date
        case ascButton:
            sortBy.0 = .asc
        case dscButton:
            sortBy.0 = .dsc
        default: break
        }
    }
}

// MARK: CollectionView
extension ShopSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
}

#if DEBUG
#Preview {
    ShopSearchResultViewController()
}
#endif
