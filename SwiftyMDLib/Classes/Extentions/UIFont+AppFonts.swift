//
//  UIFont+ AppFonts.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

public extension UIFont {
    
    func convertToAwesome(_ size: CGFloat = 15) -> UIFont{
        if let font =  UIFont(name: "FontAwesome", size: size){
            if #available(iOS 11.0, *) {
                let fontMetrics = UIFontMetrics(forTextStyle: .body)
                let scaledFont = fontMetrics.scaledFont(for: font)
                return scaledFont
            } else {
                // Fallback on earlier versions
            }
        }
        return self
    }
    
    
    
}
