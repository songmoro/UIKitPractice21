//
//  ShopRecommendedViewModel.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

final class ShopRecommendedViewModel {
    enum InputAction {
        case none
        case call
        case nextPage(itemIndex: Int)
    }
    
    private var isInprogress = false
    private let keyword: String
    @MyObservable var searchItem: ShopSearchItem
    @MyObservable var inputAction: InputAction
    
    init(keyword: String, searchItem: ShopSearchItem = .init(display: 10), inputAction: InputAction = .none) {
        self.keyword = keyword
        self._searchItem = .init(value: searchItem)
        self._inputAction = .init(value: inputAction)
        
        bind()
    }
    
    private func bind() {
        $inputAction.bind { [weak self] in
            switch $0 {
            case .call:
                self?.call()
            case .nextPage(let itemIndex):
                if self?.hasNextPage(itemIndex) ?? false {
                    self?.call()
                }
            default:
                break
            }
        }
    }
    
    private func call() {
        Task {
            self.isInprogress = true
            
            defer {
                self.isInprogress = false
            }
            
            do {
                let api = ShopAPI.search(query: keyword, display: searchItem.display, start: searchItem.page)
                
                let response = try await NetworkManager.shared.call(by: api, of: ShopResponse.self, or: ShopErrorResponse.self)
                
                searchItem.total = response.total
                searchItem.items.append(contentsOf: response.items)
            }
            catch(let error) {
                print(error)
            }
        }
    }
    
    private func hasNextPage(_ itemIndex: Int) -> Bool {
        guard !isInprogress else { return false }
        guard searchItem.hasNextPage(itemIndex) else { return false }
        
        searchItem.page += 1
        return true
    }
    
}
