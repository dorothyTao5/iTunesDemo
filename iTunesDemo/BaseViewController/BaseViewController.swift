//
//  BaseViewController.swift
//  iTunes
//
//  Created by dorothyTao on 2022/1/4.
//

import UIKit

class BaseViewController: UIViewController {

    enum Position: Int {
        case left
        case right
    }
    
    lazy var btnBack: UIButton = {
        let btn = UIButton(frame: CGRect())
        btn.setImage(R.image.button_back_normal()!, for: .normal)
        btn.setImage(R.image.button_back_pressed()!, for: .highlighted)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseViewController {
    @objc func popViewController() {
        navigationController?.base?.popViewController(animated: true)
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
