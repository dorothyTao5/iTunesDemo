//
//  BaseTabBarController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/20.
//

import UIKit

final class BaseTabBarController: UITabBarController {

    // UI element
    private let mainVC = BaseNavigationViewController(rootViewController: SearchingViewController())
    private let settingVC = BaseNavigationViewController(rootViewController: SettingViewController())
    
    // Property
    private let selectedFont = UIFont.systemFont(ofSize: 10, weight: .medium)
    private let unSelectFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    override var selectedIndex: Int {
        didSet {
            guard let selectedViewController = viewControllers?[selectedIndex] else {
                return
            }
            selectedViewController.tabBarItem.setTitleTextAttributes([.font: selectedFont], for: .normal)
        }
    }
    override var selectedViewController: UIViewController? {
        didSet {
            guard let viewControllers = viewControllers else {
                return
            }
            
            for viewController in viewControllers {
                if viewController == selectedViewController {
                    viewController.tabBarItem.setTitleTextAttributes([.font: selectedFont], for: .normal)
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([.font: unSelectFont], for: .normal)
                }
            }
        }
    }
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
       configure()
    }
    
}

extension BaseTabBarController {
    private func configure() {
        mainVC.tabBarItem = UITabBarItem(title: "Search",
                                         image: R.image.tab_search()?.withRenderingMode(.automatic),
                                         selectedImage: R.image.tab_search()?.withRenderingMode(.automatic))
        settingVC.tabBarItem = UITabBarItem(title: "Setting",
                                            image: R.image.tab_setting()?.withRenderingMode(.automatic),
                                            selectedImage: R.image.tab_setting()?.withRenderingMode(.automatic))
        
        viewControllers = [mainVC, settingVC]
        selectedIndex = 1
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: unSelectFont], for: .normal)
        
        tabBar.tintColor = R.color.black_white()!.withAlphaComponent(0.6)
        tabBar.unselectedItemTintColor = R.color.black_white()!.withAlphaComponent(0.3)
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
    }
}
extension BaseTabBarController: UITabBarControllerDelegate {
    
}
