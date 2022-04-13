//
//  SearchingTBVCell.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit
import Kingfisher
import AVFoundation
import Hero
import RxSwift
import RxCocoa

class SearchingTBVCell: UITableViewCell {

    lazy var ivPhoto = UIImageView(image: R.image.empty_photo()!)
    private lazy var bgContent: UIView = {
        let vw = UIView()
        vw.layer.borderColor = R.color.black_blue()!.cgColor
        vw.layer.borderWidth = 1
        vw.layer.cornerRadius = 4
        vw.backgroundColor = .clear
        return vw
    }()
    private lazy var lbTitle = UILabel(color: R.color.black_blue()!, fontSize: 17, weight: .medium)
    private lazy var lbArtistName = UILabel(color: R.color.black_blue()!, fontSize: 12, weight: .regular)
    private lazy var btnPlay: UIButton = {
        let btn = UIButton()
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.setImage(R.image.icon_play()!, for: .normal)
        btn.setImage(R.image.icon_play()!.opacity(0.5), for: .highlighted)
        return btn
    }()
    private lazy var separatorLine:UIView = {
        let vw = UIView()
        vw.backgroundColor = .white.withAlphaComponent(0.05)
        return vw
    }()
    
    private var gradientLayer = CAGradientLayer()
    private var colorIndex = 0
    var playPauseCallBack: (() -> Void)?
    private let disposeBag = DisposeBag()
//MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.setGradient(color: GradientType(rawValue: colorIndex) ?? .red, layoutDirection: .landscape)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: contentView.frame.height)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        lbTitle.textColor = R.color.black_blue()!
        bgContent.layer.borderColor = R.color.black_blue()!.cgColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        eventHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        gradientLayer.setGradient(color: .clear, layoutDirection: .landscape)
    }
}
//MARK: - Private Function
private extension SearchingTBVCell {
    func setupUI() {
        selectionStyle = .none
        
        bgContent.addSubview(btnPlay)
        bgContent.addSubview(lbTitle)
        bgContent.addSubview(lbArtistName)
        contentView.addSubview(ivPhoto)
        contentView.addSubview(bgContent)
        contentView.addSubview(separatorLine)
        
        btnPlay.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.right.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        lbTitle.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(55)
        }
        lbArtistName.snp.makeConstraints { make in
            make.top.equalTo(lbTitle.snp.bottom).offset(5)
            make.left.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(55)
        }
        ivPhoto.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        bgContent.snp.makeConstraints { make in
            make.left.equalTo(ivPhoto.snp.right).offset(10)
            make.top.equalToSuperview().inset(5)
            make.bottom.equalTo(separatorLine.snp.top).offset(-5)
            make.right.equalToSuperview().inset(20)
        }
        separatorLine.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func eventHandler() {
        btnPlay.rx.tap.subscribe(onNext: { [weak self] in
            self?.playPauseCallBack?()
        }).disposed(by: disposeBag)
    }
}
//MARK: - Function
extension SearchingTBVCell {
    func setupCell(data: Results, colorIndex: Int) {
        self.colorIndex = colorIndex
        gradientLayer.setGradient(color: GradientType(rawValue: colorIndex) ?? .red, layoutDirection: .landscape)
        if let url = data.artworkUrl100 {
            ivPhoto.kf.setImage(with: URL(string: url), placeholder:  R.image.empty_photo()!.opacity(0.5))
        }
        lbTitle.text  = data.trackName ?? "-"
        lbArtistName.text = data.artistName ?? "-"
        btnPlay.setImage(data.isPlaying ? R.image.icon_pause()! : R.image.icon_play()!, for: .normal)
        btnPlay.setImage(data.isPlaying ? R.image.icon_pause()!.opacity(0.5) : R.image.icon_play()!.opacity(0.5), for: .highlighted)
    }
    
    func setHeroID(id: String) {
        ivPhoto.heroID = SongHeroID.ivPhoto.rawValue + id
//        lbTitle.heroID = SongHeroID.lbTitle.rawValue + id
//        lbArtistName.heroID = SongHeroID.lbArtistName.rawValue + id
    }
}
