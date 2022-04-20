//
//  CustomTextFieldView.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit

class CustomTextFieldView: UIView {

    lazy var textFeild: UITextField = {
        let tf = UITextField()
        tf.addPadding(10, withIcon: R.image.icon_search()!, at: .left)
        tf.placeholder = "Artists or songs"
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.tintColor = R.color.black_white()!
        tf.backgroundColor = R.color.black_white()!.withAlphaComponent(0.1)
        tf.returnKeyType = .done
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
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
    }
}
//MARK: - UITextFieldDelegate
extension CustomTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.black_white()!.withAlphaComponent(0.6).cgColor
        beginEditing?()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
