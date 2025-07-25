//
//  ShoppingViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

final class ShoppingViewController: BaseViewController {
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

extension ShoppingViewController {
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

extension ShoppingViewController: UISearchBarDelegate {
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
