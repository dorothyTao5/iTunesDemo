//
//  SwitchModeTbvCell.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/20.
//

import UIKit

class SwitchModeTbvCell: UITableViewCell {

    private lazy var lbTitle = UILabel(text: "Appearance", color: R.color.black_white(), fontSize: 17, weight: .regular)
    private lazy var segmentView: CustomSegment = {
        let segment = CustomSegment(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        let isLightMode = UserDefaults.UserInfo.bool(forKey: .isLightMode)
        let isManual = UserDefaults.UserInfo.bool(forKey: .manualControlAppearance)
        if isManual {
            segment.isOnLeftSide = isLightMode
        }
        segment.shouldHalfRound = true
        segment.delegate = self
        return segment
    }()
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Private Function
private extension SwitchModeTbvCell {
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(lbTitle)
        contentView.addSubview(segmentView)
        
        lbTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        segmentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
}
//MARK: - CustomSegmentDelegate
extension SwitchModeTbvCell: CustomSegmentDelegate {
    func switchRightToLeft() {
        UserDefaults.UserInfo.set(value: true, forKey: .manualControlAppearance)
        UserDefaults.UserInfo.set(value: true, forKey: .isLightMode)
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
    }
    
    func switchLeftToRight() {
        UserDefaults.UserInfo.set(value: true, forKey: .manualControlAppearance)
        UserDefaults.UserInfo.set(value: false, forKey: .isLightMode)
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
}
