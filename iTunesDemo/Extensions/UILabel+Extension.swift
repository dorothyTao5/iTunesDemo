//
//  SearchingTBVCell.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil, color: UIColor? = nil, fontSize:CGFloat, weight:UIFont.Weight) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}
