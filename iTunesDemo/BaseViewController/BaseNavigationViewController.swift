//
//  BaseNavigationViewController.swift
//  iTunes
//
//  Created by dorothyTao on 2022/1/4.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    }
}
