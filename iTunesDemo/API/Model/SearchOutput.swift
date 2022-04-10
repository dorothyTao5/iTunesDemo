//
//  SearchOutput.swift
//  iTunes
//
//  Created by dorothyTao on 2022/2/12.
//

import UIKit

struct MusicIndexes {
    var previous: IndexPath?
    var current = IndexPath()
}

struct SearchOutput: Codable {
   var results = [Results]()
    
    mutating func updateSelectedData(at indexPath: IndexPath) -> MusicIndexes {
        var previousIndex: IndexPath?
        if let previousPlayingIndex = results.firstIndex(where: { $0.isPlaying }), previousPlayingIndex != indexPath.row {
            results[previousPlayingIndex].isPlaying = false
            previousIndex = IndexPath(row: previousPlayingIndex, section: 0)
        }
        results[indexPath.row].isPlaying.toggle()
        return MusicIndexes(previous: previousIndex, current: indexPath)
    }
}

struct Results: Codable {
    var kind: String?
    var artistName: String?
    var trackName: String?
    var previewUrl: String?
    var artworkUrl100: String?
    var isPlaying = false
    
    enum CodingKeys: String, CodingKey {
        case kind, artistName, trackName, previewUrl, artworkUrl100
    }
}
