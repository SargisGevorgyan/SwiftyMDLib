//
//  UIView+ shapeLayer.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit


public extension UIView {
    
    func applyShadowWithShapeLayer( shadowLayer: inout CAShapeLayer!, fillColor: UIColor, cornerRadius: CGFloat)-> CAShapeLayer {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
        return shadowLayer
    }
    
}
