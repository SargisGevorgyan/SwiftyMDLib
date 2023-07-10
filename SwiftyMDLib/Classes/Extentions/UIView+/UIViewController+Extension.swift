//
//  UIViewController+Extension.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 7/10/23.
//

import UIKit

public extension UIViewController {
    public static var instantiate: Self? {
        UIViewController().instantiateController(withIdentifier: Self.id) as? Self
    }
}
