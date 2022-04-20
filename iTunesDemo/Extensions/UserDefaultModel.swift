//
//  UserDefaultModel.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/20.
//

import Foundation

extension UserDefaults {
    
    struct UserInfo: UserDefaultsSettable {
        
        enum defaultKeys: String {
            case manualControlAppearance
            case isLightMode
        }
    }
    
}
