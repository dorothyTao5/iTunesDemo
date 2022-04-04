//
//  SearchingViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/1/7.
//

import UIKit

enum GradientType: Int {
    case clear = -1
    case red = 0
    case orange = 1
    case yellow
    case green
    case blue
    case purple
    
    var colorSet:[CGColor] {
        switch self {
        case .clear:
            return [UIColor.clear.cgColor,
                    UIColor.clear.cgColor]
        case .red:
            return [R.color.white_black()!.cgColor,
                    R.color.red_fbf2f2()!.cgColor]
        case .orange:
            return [R.color.white_black()!.cgColor,
                    R.color.oriange_f8efe2()!.cgColor]
        case .yellow:
            return [R.color.white_black()!.cgColor,
                    R.color.yellow_fdfde8()!.cgColor]
        case .green:
            return [R.color.white_black()!.cgColor,
                    R.color.green_eff9eb()!.cgColor]
        case .blue:
            return [R.color.white_black()!.cgColor,
                    R.color.blue_e8f2f5()!.cgColor]
        case .purple:
            return [R.color.white_black()!.cgColor,
                    R.color.purple_eeeef7()!.cgColor]
        }
    }
}
