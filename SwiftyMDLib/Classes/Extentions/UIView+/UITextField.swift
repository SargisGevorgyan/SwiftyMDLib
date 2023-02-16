//
//  UITextField+.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

let passwordShowIcon = #imageLiteral(resourceName: "eye_closed")//""
let passwordHideIcon = #imageLiteral(resourceName: "eye") // ""

public extension UITextField {
    
    var isEmpty: Bool {
        return text?.isEmpty ?? false
    }
    
    func addLeftButton() -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: bounds.height)))
        leftView = nil
        button.imageEdgeInsets.left = 0
        button.titleEdgeInsets.left = 0
        button.titleLabel?.font = font
        leftView = button
        leftViewMode = .always
        return button
    }
    
    @discardableResult
    func setupEye() -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: frame.height)))
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = button.titleLabel?.font.convertToAwesome(20)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.gray, for: .selected)
        button.setImage(passwordShowIcon, for: .normal)
        button.setImage(passwordHideIcon, for: .selected)
        button.addTarget(self, action: #selector(toggleEye(_:)), for: .touchUpInside)
        rightViewMode = .always
        addSubview(button)
        let invisiableButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: frame.height)))
        invisiableButton.alpha = 0
        invisiableButton.setImage(passwordHideIcon, for: .normal)
        rightView = button
        return button
    }
    
    @objc private func toggleEye(_ sender: UIButton)  {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = !isSecureTextEntry
        clearsOnBeginEditing = false
    }
}

public extension UITextField {
    func setCursor(position: Int) {
        let position = self.position(from: beginningOfDocument, offset: position)!
        selectedTextRange = textRange(from: position, to: position)
    }
}

public extension UIView {
    func validateDecimalNumberText(for textField: UITextField, replacementStringRange: NSRange, string: String) -> Bool {

        // Back key
        if string.isEmpty {
            return true
        }

        // Allowed charachters include decimal digits and the separator determined by number foramtter's (current) locale
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: numberFormatter.decimalSeparator))
        let characterSet = CharacterSet(charactersIn: string)

        // False if string contains not allowed characters
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        // Check for decimal separator
        if let input = textField.text {
            if let range = input.range(of: numberFormatter.decimalSeparator) {
                let endIndex = input.index(input.startIndex, offsetBy: input.distance(from: input.startIndex, to: range.upperBound))
                let decimals = input[endIndex...]

                // If the replacement string contains a decimal seperator and there is already one, return false
                if input.contains(numberFormatter.decimalSeparator) && string == numberFormatter.decimalSeparator {
                    return false
                }

                // If a replacement string is before the separator then true
                if replacementStringRange.location < endIndex.encodedOffset {
                    return true
                } else {
                    // If the string will exceed the max number of fraction digits, then return false, else true
                    return string.count + decimals.count <= numberFormatter.maximumFractionDigits
                }
            }
        }

        return true
    }
}
