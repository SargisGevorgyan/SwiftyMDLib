//
//  UIView+TouchAreaInsets.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 6/19/23.
//

import UIKit
import ObjectiveC.runtime
import Darwin

typealias DispatchOnce = @convention(c) (
    _ predicate: UnsafePointer<UInt>?,
    _ block: () -> Void
) -> Void

func dispatchOnce(_ predicate: UnsafePointer<UInt>?, _ block: () -> Void) {
    let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)

    if let sym = dlsym(RTLD_DEFAULT, "dispatch_once") {
        let f = unsafeBitCast(sym, to: DispatchOnce.self)
        f(predicate, block)
    }
    else {
        fatalError("Symbol not found")
    }
}

public extension UIView {
    private struct AssociatedKeys {
        static var touchAreaInsets = UIEdgeInsets.zero
    }

    public var touchAreaInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.touchAreaInsets) as? UIEdgeInsets {
                return value
            }
            return UIEdgeInsets.zero
        }
        set(newValue) {
            var token: UInt = 0
            dispatchOnce(&token) {
                let originalSelector = #selector(point(inside:with:))
                let swizzledSelector = #selector(_touchAreaInsets_pointInside(_:with:))

                if let originalMethod = class_getInstanceMethod(Self.self, originalSelector),
                   let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
            objc_setAssociatedObject(self, &AssociatedKeys.touchAreaInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private func _touchAreaInsets_pointInside(_ point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        bounds = CGRect(x: bounds.origin.x - touchAreaInsets.left,
                        y: bounds.origin.y - touchAreaInsets.top,
                        width: bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        height: bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom)
        return bounds.contains(point)
    }
}

