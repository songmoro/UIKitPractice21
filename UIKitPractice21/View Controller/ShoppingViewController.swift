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

class ShoppingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        navigationItem.title = "쇼핑"
    }
}
