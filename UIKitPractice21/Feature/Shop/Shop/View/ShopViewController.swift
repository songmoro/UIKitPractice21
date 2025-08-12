//
//  ShopViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit
import Then

final class ShopViewController: BaseViewController<ShopViewModel> {
    private let searchBar = UISearchBar().then {
        $0.placeholder = "브랜드, 상품, 프로필, 태그 등"
        $0.searchBarStyle = .minimal
    }
    
    override init(viewModel: ShopViewModel) {
        super.init(viewModel: viewModel)
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension ShopViewController {
    private func bind() {
        viewModel.$outputAction.bind { [weak self] in
            switch $0 {
            case .transition(let keyword):
                let vm = ShopSearchViewModel(keyword: keyword)
                let shopSearchVC = ShopSearchViewController(viewModel: vm)
                self?.transition(shopSearchVC, .push)
                
            case .showAlert(let error):
                self?.showAlert(message: error.errorDescription)
                
            case .showUnknownAlert(let message):
                self?.showAlert(message: message)
                
            default: break
            }
        }
    }
    
    private func configure() {
        configureNavigation()
        configureSubview()
        configureLayout()
        configureSearchBar()
    }
    
    private func configureNavigation() {
        navigationItem.title = "쇼핑"
    }
    
    private func configureSubview() {
        view.addSubviews(searchBar)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
}

extension ShopViewController: UISearchBarDelegate {
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputAction = .search(searchBar.text)
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
