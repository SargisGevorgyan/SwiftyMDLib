//
//  UINavigationController + Extension.swift
//
//  Copyright © 2022 MagicDevs. All rights reserved.
//

import Foundation

public extension UINavigationController {
    public func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
