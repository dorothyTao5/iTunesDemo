//
//  SearchingTBVCell.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit

extension UIImage {
    func opacity(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
