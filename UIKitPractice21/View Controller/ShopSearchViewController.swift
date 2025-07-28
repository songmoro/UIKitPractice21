//
//  ShopSearchViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit
import Then

enum ShopSearchViewControllerErrorReason: LocalizedError {
    case selectButtonIsNil
    case apiError(error: ShopAPIErrorReason)
}

final class ShopSearchViewController: BaseViewController {
    private var searchText = ""
    
    private let resultLabel = UILabel()
    
    private var selected: SortByButton? {
        willSet {
            newValue?.isSelected = true
            newValue?.isUserInteractionEnabled = false
        }
        didSet {
            oldValue?.isSelected = false
            oldValue?.isUserInteractionEnabled = true
        }
    }
    private let simButton = SortByButton(sortBy: .sim, title: "정확도")
    private let dateButton = SortByButton(sortBy: .date, title: "날짜순")
    private let ascButton = SortByButton(sortBy: .asc, title: "가격높은순")
    private let dscButton = SortByButton(sortBy: .dsc, title: "가격낮은순")
    
    private var searchItem = ShopSearchItem()
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
        selected = sender
        reset()
        call(sender)
    }
    
    private func call(_ button: SortByButton?) {
        do {
            guard let button else { throw ShopSearchViewControllerErrorReason.selectButtonIsNil }
            let api = ShopAPI.search(query: searchText, display: searchItem.display, start: searchItem.page, sort: button.sortBy.rawValue)
            
            api.call {
                switch $0 {
                case .success(let response):
                    self.handleResponse(response)
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
        catch(let error) {
            handleError(error)
        }
        
    }
    
    private func handleResponse(_ response: ShopResponse) {
        searchItem.total = response.total
        updateResultLabel(response.total)
        updateCollectionView(items: response.items)
    }
    
    private func handleError(_ error: Error) {
        print(error.localizedDescription)
        
        let alert = UIAlertController(title: nil, message: "데이터 로딩 실패", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        alert.addAction(UIAlertAction(title: "재시도", style: .default, handler: { _ in self.call(self.selected) }))
        
        present(alert, animated: true)
    }
}

// MARK: CollectionView
extension ShopSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout().then {
            let screen = UIScreen.main.bounds
            
            $0.itemSize = CGSize(width: screen.width / 2, height: screen.width / 2 + screen.width / 6)
            $0.minimumInteritemSpacing = .zero
            $0.sectionInset = .zero
        }
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ShopCell.self)
            $0.collectionViewLayout = layout
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchItem.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShopCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = searchItem.items[indexPath.item]
        cell.reload(item)
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (searchItem.items.count - 2), searchItem.total > (searchItem.items.count + searchItem.display) {
            searchItem.page += 1
            call(selected)
        }
    }
    
    private func updateCollectionView(items: [ShopItem]) {
        self.searchItem.items.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    private func reset() {
        searchItem = ShopSearchItem()
        updateResultLabel(searchItem.total)
    }
}

#if DEBUG
#Preview {
    ShopSearchViewController()
}
#endif
