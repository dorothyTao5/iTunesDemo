//
//  EmptyView.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/5.
//

import UIKit

class EmptyView: UIView {

    enum EmptyViewType {
        case noResult
        
        var title: String {
            switch self {
            case .noResult:
                return "Oops! No Result!"
            }
        }
        
        var image: UIImage {
            switch self {
            case .noResult:
                return R.image.img_note()!
            }
        }
    }
    
    enum ImagePosition {
        case center
        case upper
    }
//MARK: - Property
    private lazy var ivEmpty = UIImageView()
    private lazy var lbEmpty: UILabel = {
        let lb = UILabel(color: R.color.black_white()!.withAlphaComponent(0.4), fontSize: 18, weight: .medium)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    private lazy var leftLine:UIView = {
        let vw = UIView()
        vw.backgroundColor = R.color.black_white()!.withAlphaComponent(0.3)
        return vw
    }()
    private lazy var rightLine:UIView = {
        let vw = UIView()
        vw.backgroundColor = R.color.black_white()!.withAlphaComponent(0.3)
        return vw
    }()
    
    private var imagePosition = ImagePosition.center
//MARK: - Life Cycle
    init(withType emptyType: EmptyViewType, onPosition imagePosition: ImagePosition = .center) {
        super.init(frame: .zero)
        self.imagePosition = imagePosition
        setupUI()
        ivEmpty.image = emptyType.image
        lbEmpty.text = emptyType.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Private Functions
private extension EmptyView {
    func setupUI() {
        addSubview(ivEmpty)
        addSubview(lbEmpty)
        addSubview(leftLine)
        addSubview(rightLine)
        
        ivEmpty.snp.makeConstraints { make in
            switch imagePosition {
            case .center:
                make.center.equalToSuperview()
            case .upper:
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-70)
            }
        }
        lbEmpty.snp.makeConstraints { make in
            make.top.equalTo(ivEmpty.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        leftLine.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(32)
            make.right.equalTo(lbEmpty.snp.left).offset(-8)
            make.centerY.equalTo(lbEmpty)
            make.height.equalTo(1)
        }
        rightLine.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(32)
            make.left.equalTo(lbEmpty.snp.right).offset(8)
            make.centerY.equalTo(lbEmpty)
            make.height.equalTo(1)
        }
    }
}
