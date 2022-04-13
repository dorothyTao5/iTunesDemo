//
//  CurrentSongViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/5.
//

import UIKit
import Hero

protocol CurrentSongVCDelegate: AnyObject {
    func updatePlayingData()
    func updateSearchingVCTBV()
}
class CurrentSongViewController: BaseViewController {
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(R.image.icon_doubleDown()!, for: .normal)
        return btn
    }()
    private lazy var btnPlay: UIButton = {
        let btn = UIButton()
        btn.setImage(R.image.icon_play()!, for: .normal)
        btn.setImage(R.image.icon_play()!.opacity(0.5), for: .highlighted)
        btn.layer.cornerRadius = 25
        btn.backgroundColor = R.color.black_white()!.withAlphaComponent(0.2)
        return btn
    }()
    private lazy var ivPhoto = UIImageView(image: R.image.empty_photo()!)
    private lazy var lbTitle: UILabel = {
        let lb = UILabel(color: R.color.black_blue()!, fontSize: 25, weight: .medium)
        lb.numberOfLines = 0
        return lb
    }()
    private lazy var lbArtistName: UILabel = {
        let lb = UILabel(color: R.color.black_blue()!, fontSize: 15, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()

    var heroid = "0"
    weak var delegate: CurrentSongVCDelegate?
    private var resultData = Results()
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setHeroID(heroid)
        eventHandler()
    }
}
//MARK: - Private Functions
private extension CurrentSongViewController {
    func setupUI() {
        view.backgroundColor = R.color.white_black()
        view.addSubview(backButton)
        view.addSubview(ivPhoto)
        view.addSubview(lbTitle)
        view.addSubview(btnPlay)
        view.addSubview(lbArtistName)
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        ivPhoto.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.centerX.equalToSuperview()
        }
        lbTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(80)
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(btnPlay.snp.right).offset(8)
            make.top.equalTo(ivPhoto.snp.bottom).offset(40)
        }
        btnPlay.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(50)
            make.top.equalTo(ivPhoto.snp.bottom).offset(40)
        }
        lbArtistName.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(lbTitle.snp.bottom).offset(10)
        }
    }
    
    func setHeroID(_ id: String) {
        isHeroEnabled = true
        ivPhoto.heroID = SongHeroID.ivPhoto.rawValue + id
        
        ivPhoto.heroModifiers = [.duration(1)]
        lbTitle.heroModifiers = [.duration(1)]
        lbArtistName.heroModifiers = [.duration(1)]
    }
    
    func setBtnPlayImage(isPlaying: Bool) {
        self.btnPlay.setImage(isPlaying ? R.image.icon_pause()! : R.image.icon_play()!, for: .normal)
        self.btnPlay.isSelected = isPlaying
    }
    
    func eventHandler() {
        btnPlay.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.setBtnPlayImage(isPlaying: !self.btnPlay.isSelected)
            self.resultData.isPlaying = self.btnPlay.isSelected
            PlayerManager.shared.playMusic(currentSong: self.resultData)
            self.delegate?.updatePlayingData()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.delegate?.updateSearchingVCTBV()
            self.dismissViewController()
        }).disposed(by: disposeBag)
    }
}
//MARK: - Function
extension CurrentSongViewController {
    func setupView(heroID: String, data: Results, photo: UIImage) {
        ivPhoto.image = photo
        self.resultData = data
        self.lbTitle.text = data.trackName ?? "No Title"
        self.lbArtistName.text = data.artistName ?? "-"
        self.setBtnPlayImage(isPlaying: data.isPlaying)
    }
}
