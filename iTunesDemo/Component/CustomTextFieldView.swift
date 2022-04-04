//
//  CustomTextFieldView.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit

class CustomTextFieldView: UIView {

    private lazy var textFeild: UITextField = {
        let tf = UITextField()
        tf.addPadding(10, withIcon: R.image.icon_search()!, at: .left)
        tf.placeholder = "Artists or songs"
        tf.layer.borderWidth = 1
        tf.layer.borderColor = R.color.black_blue()!.cgColor
        tf.layer.cornerRadius = 4
        tf.tintColor = R.color.black_white()!
        tf.delegate = self
        return tf
    }()
    
    private var debounceTimer: Timer?
    var endEditingCallback: ((String) -> Void)?
    var beginEditing: (() -> Void)?
//MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Private Extension
private extension CustomTextFieldView {
    func setupUI() {
        addSubview(textFeild)
        
        textFeild.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - UITextFieldDelegate
extension CustomTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        beginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditingCallback?(textField.text ?? "")
        textField.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.endEditingCallback?(textField.text ?? "")
        }
        return true
    }
    
}
