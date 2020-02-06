//
//  UIView+ cornerRadius.swift
//  LatinCamp
//
//  Created by Davit Ghushchyan on 7/4/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
   
}
