//
//  CALayer+Extension.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//


import UIKit

 public extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
    
    func applySketchShadow(
        color: UIColor = UIColor.black,
        alpha: CGFloat = 0.26,
        opacity: Float = 1.0,
        x: CGFloat = 0,
        y: CGFloat = 8,
        blur: CGFloat = 32,
        spread: CGFloat = 0)
    {
        let col = color.withAlphaComponent(alpha)
        shadowColor = col.cgColor
        shadowOpacity = opacity
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    
    
}
