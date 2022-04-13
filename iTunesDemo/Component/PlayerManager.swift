//
//  PlayerManager.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/12.
//

import MediaPlayer

class PlayerManager: NSObject {
    
    static let shared = PlayerManager()
    
    let player = AVPlayer()
    
    func playMusic(currentSong: Results) {
        guard let previewUrl = currentSong.previewUrl,
                  currentSong.isPlaying else {
                      PlayerManager.shared.player.pause()
                      return
                  }
        let url = URL(string: previewUrl)!
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        print(self.player.currentItem?.seekableTimeRanges.first?.timeRangeValue.duration)
    }
}
