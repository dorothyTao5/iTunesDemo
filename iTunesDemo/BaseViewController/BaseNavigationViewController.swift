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

    @discardableResult
    func setTransparentBar() -> Self {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        return self
    }
    
    @discardableResult
    func setBarTintColor(color: UIColor) -> Self {
        navigationBar.barTintColor = color
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        return self
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

extension UINavigationController {
    var base: BaseNavigationViewController? {
        return self as? BaseNavigationViewController
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
