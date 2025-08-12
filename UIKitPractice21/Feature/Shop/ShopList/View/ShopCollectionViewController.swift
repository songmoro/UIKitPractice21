//
//  ShopCollectionViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit
import Then

fileprivate enum ShopCollectionViewControllerErrorReason: Error {
    case selectButtonIsNil
}

final class ShopCollectionViewController: BaseViewController<ShopCollectionViewModel> {
    private let resultLabel = UILabel()
    
    private let simButton = SortByButton(sortBy: .sim, title: "정확도")
    private let dateButton = SortByButton(sortBy: .date, title: "날짜순")
    private let ascButton = SortByButton(sortBy: .asc, title: "가격높은순")
    private let dscButton = SortByButton(sortBy: .dsc, title: "가격낮은순")
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(viewModel: ShopCollectionViewModel) {
        super.init(viewModel: viewModel)
        bind()
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        sortByButtonClicked(simButton)
    }
}

// MARK: Configure
private extension ShopCollectionViewController {
    private func bind() {
        viewModel.$outputAction.bind { [weak self] in
            switch $0 {
            case .updateButton(let sortBy):
                DispatchQueue.main.async {
                    [self?.simButton, self?.dateButton, self?.ascButton, self?.dscButton].compactMap(\.self)
                        .forEach { button in
                            button.isSelected = button.sortBy == sortBy
                            button.isUserInteractionEnabled = button.sortBy != sortBy
                        }
                }
                
            case .updateLabel(let text):
                DispatchQueue.main.async {
                    self?.updateResultLabel(text)
                }
                
            case .showAlert(let message, let isHandleable):
                DispatchQueue.main.async {
                    self?.handleError(message: message, isHandleable: isHandleable)
                }
                
            default:
                break
            }
        }
        
        viewModel.$searchItem.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
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
    }
}

// MARK: Update
extension ShopCollectionViewController {
    private func updateResultLabel(_ text: String) {
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.systemGreen])
        resultLabel.attributedText = attributedText
    }
    
    @objc private func sortByButtonClicked(_ sender: SortByButton) {
        viewModel.inputAction = .select(sender.sortBy)
    }
    
    private func handleError(message: String, isHandleable: Bool = true) {
        if isHandleable {
            showAlert(message: message, defaultTitle: "재시도") { [weak self] in
                // retry
            }
        }
        else {
            showAcceptAlert(message: "다시 검색해주세요.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: CollectionView
extension ShopCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        viewModel.searchItem.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShopCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = viewModel.searchItem.items[indexPath.item]
        cell.reload(item)
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.inputAction = .nextPage(itemIndex: indexPath.item)
    }
}
