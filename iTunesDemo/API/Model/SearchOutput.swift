//
//  SearchOutput.swift
//  iTunes
//
//  Created by dorothyTao on 2022/2/12.
//

import Foundation

struct SearchOutput: Codable {
   var results = [Results]()
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
