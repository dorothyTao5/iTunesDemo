//
//  SearchingTBVCell.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit

extension UITextField {
    enum Position {
        case left
        case right
    }
    
    func addPadding(_ padding: CGFloat, withIcon image: UIImage? = nil, at positon: Position = .left) {
        let iconView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: (image?.size.width ?? 0) + padding,
                                            height: image?.size.height ?? frame.height))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        switch positon {
        case .left:
            leftView = iconView
            leftViewMode = .always
        case .right:
            rightView = iconView
            rightViewMode = .always
        }
    }
}
