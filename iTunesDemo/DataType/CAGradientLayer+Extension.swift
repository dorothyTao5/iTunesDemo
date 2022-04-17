//
//  SearchingViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/1/7.
//

import UIKit

enum GradientType: Int {
    case clear = -1
    case blueSix = 0
    case blueFive = 1
    case blueFour
    case blueThree
    case blueTwo
    case blueOne
    
    var colorSet:[CGColor] {
        switch self {
        case .clear:
            return [UIColor.clear.cgColor,
                    UIColor.clear.cgColor]
        case .blueSix:
            return [R.color.white_black()!.cgColor,
                    R.color.blueSix()!.cgColor]
        case .blueFive:
            return [R.color.white_black()!.cgColor,
                    R.color.blueFive()!.cgColor]
        case .blueFour:
            return [R.color.white_black()!.cgColor,
                    R.color.blueFour()!.cgColor]
        case .blueThree:
            return [R.color.white_black()!.cgColor,
                    R.color.blueThree()!.cgColor]
        case .blueTwo:
            return [R.color.white_black()!.cgColor,
                    R.color.blueTwo()!.cgColor]
        case .blueOne:
            return [R.color.white_black()!.cgColor,
                    R.color.blueOne()!.cgColor]
        }
    }
}
