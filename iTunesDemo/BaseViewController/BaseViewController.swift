//
//  BaseViewController.swift
//  iTunes
//
//  Created by dorothyTao on 2022/1/4.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    enum Position: Int {
        case left
        case right
    }
    
    private lazy var btnBack:UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let btnItem = UIBarButtonItem(customView: btn)
        btn.setImage(R.image.button_back_normal(), for: .normal)
        btn.setImage(R.image.button_back_normal()!.opacity(0.5), for: .highlighted)
        btn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return btnItem
    }()
    
    let disposeBag = DisposeBag()
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BaseViewController {
    func addBackButton(at position: Position = .left) {
        switch position {
        case .left:
            navigationItem.setLeftBarButton(btnBack, animated: true)
        case .right:
            navigationItem.setRightBarButton(btnBack, animated: true)
        }
    }
    
    func configureNavigationAppearance(color: UIColor?, foregroundColor: UIColor = .white) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = color
            appearance.shadowColor = nil
            appearance.titleTextAttributes = [.foregroundColor: foregroundColor, .font: UIFont.systemFont(ofSize: 16, weight: .medium)]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.barTintColor = color
        }
    }
    
    func setUpAttribute(title:String, in color:UIColor) {
        let titleAttr = [NSAttributedString.Key.foregroundColor: color]
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = titleAttr
    }
}
//MARK: - @objc Functions
extension BaseViewController {
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
            return navigationController?.viewControllers.count ?? 0 > 1
        }
        return true
    }
}
