//
//  ShopViewModel.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

import Foundation

final class ShopViewModel {
    enum InputAction {
        case none
        case search(String?)
    }
    
    enum OutputAction {
        case none
        case transition(keyword: String)
        case showAlert(error: LocalizedError)
        case showUnknownAlert(message: String)
    }
    
    @MyObservable var inputAction: InputAction
    @MyObservable private(set) var outputAction: OutputAction
    
    init(inputAction: InputAction = .none, outputAction: OutputAction = .none) {
        self._inputAction = .init(value: inputAction)
        self._outputAction = .init(value: outputAction)
        
        bind()
    }
    
    private func bind() {
        $inputAction.bind { [weak self] in
            switch $0 {
            case .search(let text):
                self?.outputAction = self?.validate(text) ?? .none
            default: break
            }
        }
    }
    
    private func validate(_ text: String?) -> OutputAction {
        do {
            guard let text else { throw ShopViewModelErrorReason.textIsNil }
            guard text.count >= 2 else { throw ShopViewModelErrorReason.textIsLowerThanTwo }
            
            return .transition(keyword: text)
        }
        catch let error as ShopViewModelErrorReason {
            return .showAlert(error: error)
        }
        catch {
            return .showUnknownAlert(message: "다시 시도해주세요.")
        }
    }
}
