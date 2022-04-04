//
//  CAGradientLayer+Entension.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import UIKit

extension CAGradientLayer {
    
    enum LayoutDirection {
        case topLeftToBottomRight
        case landscape
        case topToBottom
        
        var startPoint: CGPoint {
            switch self {
            case .topLeftToBottomRight:
                return CGPoint(x: 0, y: 0)
            case .landscape:
                return CGPoint(x: 0, y: 0.5)
            case .topToBottom:
                return CGPoint(x: 0, y: 0)
            }
        }
        var endPoint: CGPoint {
            switch self {
            case .topLeftToBottomRight:
                return CGPoint(x: 0.8, y: 0.7)
            case .landscape:
                return CGPoint(x: 1, y: 0.5)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 1)
            }
        }
    }

    func setGradient(color: GradientType, layoutDirection:LayoutDirection) {
        self.frame = bounds
        self.colors = color.colorSet
        self.startPoint = layoutDirection.startPoint
        self.endPoint = layoutDirection.endPoint
    }
}
