//
//  ShopViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import Alamofire
import SnapKit

fileprivate enum ShopViewControllerErrorReason: LocalizedError {
    case textIsNil
    case textIsLowerThanTwo
    case navigationControllerIsNil
    
    var errorDescription: String? {
        switch self {
        case .textIsNil: "검색 값이 비어있음"
        case .textIsLowerThanTwo: "검색 값이 두 글자 이하"
        case .navigationControllerIsNil: "네비게이션 컨트롤러가 존재하지 않음"
        }
    }
}

final class ShopViewController: BaseViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension ShopViewController {
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
        search(searchBar.text)
    }
    
    private func search(_ text: String?) {
        do {
            guard let text else { throw ShopViewControllerErrorReason.textIsNil }
            guard text.count >= 2 else { throw ShopViewControllerErrorReason.textIsLowerThanTwo }
            
            let vc = ShopSearchViewController()
            vc.input(text: text)
            
            guard let navigationController else { throw ShopViewControllerErrorReason.navigationControllerIsNil }
            navigationController.pushViewController(vc, animated: true)
        }
        catch(let error) {
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
