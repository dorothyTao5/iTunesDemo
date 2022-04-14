//
//  CurrentSongViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/5.
//

import AVKit
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
    
    private lazy var playerBg: UIView = {
        let vw = UIView()
        vw.backgroundColor = .clear
        vw.layer.borderWidth = 2
        vw.layer.borderColor = R.color.black_white()!.withAlphaComponent(0.2).cgColor
        vw.layer.cornerRadius = 8
        return vw
    }()
    private lazy var slider: UISlider = {
        let slider = UISlider()
//        slider.
        return slider
    }()

    var heroid = "0"
    weak var delegate: CurrentSongVCDelegate?
    private var resultData = Results()
//    let manager = PlayerManager.shared
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setHeroID(heroid)
        eventHandler()
        PlayerManager.shared.setupRemoteTransportControls()
        PlayerManager.shared.delegate = self
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
        view.addSubview(playerBg)
        
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
        playerBg.snp.makeConstraints { make in
            make.top.equalTo(lbArtistName.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
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
        self.btnPlay.setImage(isPlaying ? R.image.icon_stop()! : R.image.icon_play()!, for: .normal)
        self.btnPlay.isSelected = isPlaying
    }
    
    func eventHandler() {
        btnPlay.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if !self.btnPlay.isSelected {
                PlayerManager.shared.playMusic(currentSong: self.resultData)
            } else {
                PlayerManager.shared.player.pause()
            }
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.delegate?.updateSearchingVCTBV()
            self.dismissViewController()
        }).disposed(by: disposeBag)
        
        slider.rx.value.asObservable()
            .subscribe { value in
                print("**&** slider value = ",value)
            }.disposed(by: disposeBag)

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
//MARK: - PaulPlayerDelegate
extension CurrentSongViewController: PaulPlayerDelegate {
    func didUpdatePosition(_ player: AVPlayer?, _ position: PlayerPosition) {
        print("**&** percentage for slider= ",Float(position.current)/Float(position.duration))
        print("**&** min = ",String(format: "%02d:%02d", position.current/60, position.current%60))
        print("**&** max = ",String(format: "%02d:%02d", position.duration/60, position.duration%60))
    }
    
    func didReceiveNotification(player: AVPlayer?, notification: Notification.Name) {
        switch notification {
        case .PlayerUnknownNotification:
            PlayerManager.shared.stopPlayer()
        case .PlayerReadyToPlayNotification:
            break
        case .PlayerDidToPlayNotification:
            self.setBtnPlayImage(isPlaying: true)
            self.resultData.isPlaying = true
        case .PlayerFailedNotification:
            let alert = UIAlertController(title: "警告⚠️", message: "無法播放", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        case .PauseNotification:
            self.setBtnPlayImage(isPlaying: false)
            self.resultData.isPlaying = false
        case .PlayerPlayFinishNotification:
            PlayerManager.shared.stopPlayer()
        default:
            break
        }
        self.delegate?.updatePlayingData()
    }
}
