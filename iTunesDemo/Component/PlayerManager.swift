//
//  PlayerManager.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/12.
//

import MediaPlayer

public protocol PaulPlayerDelegate: AnyObject {
    func didReceiveNotification(player: AVPlayer?, notification: Notification.Name)
    func didUpdatePosition(_ player: AVPlayer?,_ position: PlayerPosition)
}

public struct PlayerPosition {
    public var duration: Int = 0
    public var current: Int = 0
}

class PlayerManager: NSObject {
    
    static let shared = PlayerManager()
    
    var player = AVPlayer()
    var playerObserver: Any?
    private var position = PlayerPosition()
    weak var delegate: PaulPlayerDelegate?
    var current = 0
    var maxCount = 0
    private(set) var isSeekInProgress = false
    
//MARK: - observeValue
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            // Switch over status value
            switch status {
            case .readyToPlay:
                delegate?.didReceiveNotification(player: self.player, notification: .PlayerReadyToPlayNotification)
                self.startPlayer()
                print("**&** playerstatus.readyToPlay")
            case .failed:
                delegate?.didReceiveNotification(player: self.player, notification: .PlayerFailedNotification)
                print("**&** playerstatus.failed")
            case .unknown:
                delegate?.didReceiveNotification(player: self.player, notification: .PlayerUnknownNotification)
                print("**&** playerstatus.unknown")
            @unknown default:
                print("@unknown default")
            }
        }
        // handle keypath callback
        if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            if let isPlaybackLikelyToKeepUp = player.currentItem?.isPlaybackLikelyToKeepUp,
               player.timeControlStatus != .playing && !isPlaybackLikelyToKeepUp {
                delegate?.didReceiveNotification(player: player, notification: .PlayerBufferingStartNotification)
                print("**&** playerstatus.bufferstart")
            } else if player.timeControlStatus == .paused {
                delegate?.didReceiveNotification(player: self.player, notification: .PauseNotification)
            } else {
                delegate?.didReceiveNotification(player: player, notification: .PlayerBufferingEndNotification)
                print("**&** playerstatus.bufferend")
            }
        }
    }
}
//MARK: - Functions
extension PlayerManager {
    func playMusic(currentSong: Results) {
            let asset = AVURLAsset(url: URL(string: currentSong.previewUrl ?? "")!)
            let item = AVPlayerItem(asset: asset)
            item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
            DispatchQueue.main.async {
                self.player.replaceCurrentItem(with: item)
                self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.new], context: nil)
                self.addTimeObserve()
                self.player.allowsExternalPlayback = true
                self.player.usesExternalPlaybackWhileExternalScreenIsActive = true
            }
        }
    
    func stopPlayer()  {
        self.player.pause()
        self.player.replaceCurrentItem(with: nil)
        self.removePlayerObserve()
        self.removeTimeObserve()
        NotificationCenter.default.removeObserver(self)
    }
    
    func seekTo(_ progress:Double) {
        self.isSeekInProgress = true
        if let currentItem = self.player.currentItem, currentItem.seekableTimeRanges.count > 0 {
            guard let range = self.player.currentItem?.seekableTimeRanges.first?.timeRangeValue else { return }
            let position = CMTimeGetSeconds(range.start) + (CMTimeGetSeconds(range.duration) * progress)
            let pos = CMTimeMakeWithSeconds(position, preferredTimescale: range.duration.timescale)
            
            self.player.seek(to: pos, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (isFinished:Bool) in
                
                self.delegate?.didUpdatePosition(self.player, self.position)
                self.isSeekInProgress = false
            })
        }
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            guard self.player.rate == 0.0 else { return .commandFailed }
            self.player.play()
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            guard self.player.rate == 1.0 else { return .commandFailed }
            self.player.pause()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent{
                let percent = Float(event.positionTime)/Float(self.position.duration)
                print("change playback",percent)
                seekTo(Double(percent))
            }
            return .success
        }
    }
}
//MARK: - Private Functions
private extension PlayerManager {
     func startPlayer() {
        self.player.play()
        delegate?.didReceiveNotification(player: self.player, notification: .PlayerDidToPlayNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerNotification(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerNotification(notification:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime, object: self.player.currentItem)
    }
    
     func removePlayerObserve() {
        self.player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), context: nil)
        self.player.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: nil)
    }
    
    func removeTimeObserve() {
        if let observer = self.playerObserver {
            self.player.removeTimeObserver(observer)
        }
    }
    
    @objc func playerNotification(notification: Notification) {
        switch notification.name {
        case .AVPlayerItemDidPlayToEndTime:
            delegate?.didReceiveNotification(player: self.player, notification: .PlayerPlayFinishNotification)
        case .AVPlayerItemFailedToPlayToEndTime:
            delegate?.didReceiveNotification(player: self.player, notification: .PlayerFailedNotification)
        default:
            break
        }
    }
    
    func addTimeObserve() {
        self.playerObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: .main, using: { [weak self] (time) in
            guard let self = self else { return }
            if let currentItem = self.player.currentItem {
                let loadedRanges = currentItem.seekableTimeRanges
                guard let range = loadedRanges.first?.timeRangeValue,range.start.timescale > 0, range.duration.timescale > 0 else {
                    return
                }
                let duration = (CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration))
//                print("duration = ",duration)
                if !range.duration.flags.contains(.valid) || 0 >= duration{
                    return
                }
                let currentTime = currentItem.currentTime()
                self.position = PlayerPosition(duration: Int(duration), current: Int(CMTimeGetSeconds(currentTime)))
                if !self.isSeekInProgress {
                    self.delegate?.didUpdatePosition(self.player, self.position)
                }
            }
        })
    }
}
