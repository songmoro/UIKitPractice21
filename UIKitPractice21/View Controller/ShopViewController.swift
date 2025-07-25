//
//  ShopViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import Alamofire
import SnapKit

fileprivate enum ShopViewControllerErrorReason: Error {
    case textIsNil
    case textIsLowerThanTwo
    case urlIsInvalid
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
            
            try call(text)
            
        }
        catch(let error) {
            print(error)
        }
    }
    
    private func call(_ text: String) throws {
        let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?query=\(text)")
        guard let url else { throw ShopViewControllerErrorReason.urlIsInvalid }
        
        let headers = HTTPHeaders([
            "X-Naver-Client-Id": APIKey.naverClientId,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ])
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: ShopResponse.self) { response in
                self.navigationController?.pushViewController(ShopSearchResultViewController(), animated: true)
            }
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
