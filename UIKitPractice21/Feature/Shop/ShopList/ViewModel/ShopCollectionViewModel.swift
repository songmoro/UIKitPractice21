//
//  ShopCollectionViewModel.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

import Foundation

enum ShopCollectionViewModelErrorReason: LocalizedError {
    case error(response: ShopErrorResponse)
    case invalid(response: Decodable)
    
    var errorDescription: String? {
        switch self {
        case .error(let response):
            return response.errorMessage
        case .invalid:
            return "검색 결과를 불러오는 데 실패했습니다."
        }
    }
}

final class ShopCollectionViewModel {
    enum InputAction {
        case none
        case select(SortBy)
        case nextPage(itemIndex: Int)
        case retry
    }
    
    enum OutputAction {
        case none
        case updateButton(SortBy)
        case updateLabel(String)
        case showAlert(message: String, isHandleable: Bool)
    }
    
    let keyword: String
    
    @MyObservable var inputAction: InputAction
    @MyObservable private(set) var outputAction: OutputAction
    @MyObservable var searchItem: ShopSearchItem
    @MyObservable var selected: SortBy
    
    init(keyword: String, inputAction: InputAction = .none, outputAction: OutputAction = .none, searchItem: ShopSearchItem = ShopSearchItem(), selected: SortBy = .sim) {
        self.keyword = keyword
        self._inputAction = .init(value: inputAction)
        self._outputAction = .init(value: outputAction)
        self._searchItem = .init(value: searchItem)
        self._selected = .init(value: selected)
        
        bind()
    }
    
    private func bind() {
        $inputAction.bind { [weak self] in
            switch $0 {
            case .select(let sortBy):
                self?.reset()
                self?.selected = sortBy
                self?.outputAction = .updateButton(sortBy)
                self?.handleRequest(sortBy: sortBy)
                
            case .nextPage(let itemIndex):
                if self?.hasNextPage(itemIndex) ?? false {
                    print(#function, itemIndex)
                    self?.handleRequest(sortBy: self?.selected ?? .sim)
                }
                
            default:
                break
            }
        }
    }
    
    private func handleRequest(sortBy: SortBy) {
        Task {
            do {
                let result = try await call(sortBy)
                
                if let error = result as? ShopErrorResponse {
                    throw ShopCollectionViewModelErrorReason.error(response: error)
                }
                guard let response = result as? ShopResponse else {
                    throw ShopCollectionViewModelErrorReason.invalid(response: result)
                }
                
                outputAction = .updateLabel("\(response.total.formatted()) 개의 검색 결과")
                searchItem.total = response.total
                searchItem.items.append(contentsOf: response.items)
            }
            catch let error as APIErrorReason {
                outputAction = .showAlert(message: error.localizedDescription, isHandleable: false)
            }
            catch let error {
                outputAction = .showAlert(message: error.localizedDescription, isHandleable: true)
            }
        }
    }
    
    private func call(_ sortBy: SortBy) async throws -> Decodable {
        let api = ShopAPI.search(query: keyword, display: searchItem.display, start: searchItem.page, sort: sortBy.rawValue)
        return try await NetworkManager.shared.call(by: api, of: ShopResponse.self, or: ShopErrorResponse.self)
    }
    
    private func hasNextPage(_ itemIndex: Int) -> Bool {
        // TODO: 한 번에 한 요청씩만 처리해야함
        // 현재는 여러 요청이 한 번에 들어와서 그로인해 여러 네트워크 요청이 이뤄짐
        if searchItem.hasNextPage(itemIndex) {
            searchItem.page += 1
            return true
        }
        return false
    }
    
    private func retry() {
        
    }
    
    private func reset() {
        searchItem = .init()
    }
}
