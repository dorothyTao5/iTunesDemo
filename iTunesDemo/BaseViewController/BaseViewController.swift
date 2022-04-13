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
}
//MARK: - @objc Functions
extension BaseViewController {
    @objc func popViewController() {
//        navigationController?.base?.popViewController(animated: true)
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
