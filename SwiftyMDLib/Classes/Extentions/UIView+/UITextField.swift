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
