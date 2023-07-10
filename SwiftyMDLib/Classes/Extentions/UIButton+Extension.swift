//
//  UIButton+Extension.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 8/5/20.
//

import Foundation

public extension UIButton {
    func addUndlerLineFor(_ title:String, for state: UIControl.State = .normal) {
        guard let text = self.title(for: state) else { return }
        guard let range = text.range(of: title) else { return }
        let titleRange = NSRange(range, in: text)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: state)!, range: titleRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: state)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: titleRange)
        self.setAttributedTitle(attributedString, for: state)
    }
}
