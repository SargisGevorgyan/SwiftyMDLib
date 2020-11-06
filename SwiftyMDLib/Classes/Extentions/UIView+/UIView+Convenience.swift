//
//  UIView+Convenience.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

public extension UIView {
    
    func setFrameX(_ x: CGFloat) {
        var _frame = frame
        _frame.origin.x = x
        frame = _frame
    }
    
    func  getFrameX() -> CGFloat {
        return frame.origin.x
    }
    
    func setFrameY(_ y : CGFloat) {
        var _frame = frame
        _frame.origin.y = y
        frame = _frame
    }
    
    func getFrameY() -> CGFloat {
        return frame.origin.y
    }
    
    func setFrameWidth(_ width : CGFloat) {
        var _frame = frame
        _frame.size.width = width
        frame = _frame
    }
    
    func getFrameWidth() -> CGFloat {
        return frame.size.width
    }
    
    func setFrameHeight(_ height : CGFloat) {
        var _frame = frame
        _frame.size.height = height
        frame = _frame
    }
    
    func getFrameHeight() -> CGFloat {
        return frame.size.height
    }
    
    func setCenterX(_ centerX : CGFloat) {
        var _center = center
        _center.x = centerX
        center = _center
    }
    
    func  getCenterX() -> CGFloat {
        return center.x
    }
    
    func setCenterY(_ centerY : CGFloat) {
        var _center = center
        _center.y = centerY
        center = _center
    }
    
    func  getCenterY() -> CGFloat {
        return center.y
    }
    
    static func resizeSubViewConstraints(deviceScale : CGFloat = UIDevice.scale, view : UIView) {
        for sview in view.subviews {
            if sview is UISwitch {
                continue
            }
            resizeConstraints(deviceScale: deviceScale, view: sview)
            
            resizeSubViewConstraints(deviceScale: deviceScale, view: sview)
            if let stack =  sview as? UIStackView {
                stack.spacing = stack.spacing.scaled
            }
        }
        view.layoutIfNeeded()
    }
    
    static func resizeConstraints(deviceScale : CGFloat = UIDevice.scale, view : UIView) {
        for layoutConstraint in view.constraints {
            if layoutConstraint.multiplier == 1 {
                layoutConstraint.constant *= deviceScale
            }
        }
    }
    
    static func scaleViewFontSize(deviceScale : CGFloat = UIDevice.scale, view : UIView) {
        if let label = view as? UILabel {
            let font = label.font!
            label.font = UIFont(name: font.fontName, size: font.pointSize*deviceScale)
            return
        }
        if let button = view as? UIButton {
            if let font = button.titleLabel?.font {
                button.titleLabel?.font = UIFont(name: font.fontName, size: font.pointSize*deviceScale)
                return
            }
        }
        if let textField = view as? UITextField {
            let font = textField.font!
            textField.font = UIFont(name: font.fontName, size: font.pointSize*deviceScale)
            return
        }
        if let textView = view as? UITextView {
            let font = textView.font!
            textView.font = UIFont(name: font.fontName, size: font.pointSize*deviceScale)
            return
        }
    }
    
    static func scaleSubViewsFontSizes(deviceScale : CGFloat = UIDevice.scale, view : UIView) {
        for sview in view.subviews {
            if sview is UITableView || sview is UICollectionView {
                return
            }
            if  sview is UILabel || sview is UIButton || sview is UITextField || sview is UITextView {
                scaleViewFontSize(deviceScale: deviceScale, view: sview)
            } else {
                scaleSubViewsFontSizes(deviceScale: deviceScale, view: sview)
            }
        }
    }
}


public extension UIView {
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }

    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        if let firstItem = constraint.firstItem as? UIView, let secondItem = constraint.secondItem as? UIView {
            let firstItemMatch = firstItem == self && constraint.firstAttribute == layoutAttribute
            let secondItemMatch = secondItem == self && constraint.secondAttribute == layoutAttribute
            return firstItemMatch || secondItemMatch
        }
        return false
    }
}
