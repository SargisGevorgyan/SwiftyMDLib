//
//  UIFont+ AppFonts.swift
//  PersonalLawyer
//
//  Created by Davit Ghushchyan on 7/16/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

extension UIFont {
    
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
