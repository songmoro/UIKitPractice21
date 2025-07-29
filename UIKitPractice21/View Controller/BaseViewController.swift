//
//  BaseViewController.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 7/25/25.
//

import UIKit

class BaseViewController: UIViewController {
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func showAlert(title: String? = nil, message: String? = nil, defaultTitle: String? = nil, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        
        if let defaultTitle, let handler {
            alertController.addAction(UIAlertAction(title: defaultTitle, style: .default, handler: { _ in handler() }))
        }
        
        present(alertController, animated: true)
    }
}
