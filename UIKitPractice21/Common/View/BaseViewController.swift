//
//  BaseViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit
import SnapKit

enum TransitionStyle {
    case present
    case presentNavigation
    case push
}

class BaseViewController<ViewModel>: UIViewController {
    var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    final func transition<T: UIViewController>(_ viewController: T, _ style: TransitionStyle) {
        switch style {
        case .present:
            present(viewController, animated: true)
        case .presentNavigation:
            present(UINavigationController(rootViewController: viewController), animated: true)
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    final func showAlert(title: String? = nil, message: String? = nil, defaultTitle: String? = nil, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        
        if let defaultTitle, let handler {
            alertController.addAction(UIAlertAction(title: defaultTitle, style: .default, handler: { _ in handler() }))
        }
        
        present(alertController, animated: true)
    }
    
    final func showAcceptAlert(title: String? = nil, message: String? = nil, defaultTitle: String? = "확인", handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: defaultTitle, style: .default, handler: { _ in handler?() }))
        
        present(alertController, animated: true)
    }
    
    final func showToast(_ message: String) {
        let uiView: UIView = {
            let view = UIView()
            view.backgroundColor = .label
            view.layer.cornerRadius = 8
            
            return view
        }()
        let label: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .systemBackground
            
            return label
        }()
        
        view.addSubview(uiView)
        uiView.addSubview(label)
        
        uiView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(label).multipliedBy(1.5)
            $0.width.equalTo(label).multipliedBy(1.2)
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            uiView.removeFromSuperview()
        }
    }
}
