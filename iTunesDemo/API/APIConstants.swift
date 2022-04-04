//
//  APIConstants.swift
//  iTunes
//
//  Created by dorothyTao on 2022/2/11.
//

import Foundation

struct APIConstants {
    struct Server {
        #if DEBUG
        static let baseURL = URL(string: "https://itunes.apple.com")!
        #else
        static let baseURL = URL(string: "https://itunes.apple.com")!
        #endif
    }
}
