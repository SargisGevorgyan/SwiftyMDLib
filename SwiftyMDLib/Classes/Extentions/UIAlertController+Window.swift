//
//  UIAlertController+Window.swift
//  Dasaran
//
//  Created by Sargis Gevorgyan on 11/4/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    func show(_ animated : Bool = true) {
        DispatchQueue.main.async() {
            if  let currentController = self.appCurrentController() {
                currentController.present(self, animated: animated, completion: nil)
            }
            else {
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel =  .alert + 1
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(self, animated: animated, completion: nil)
            }
        }
    }
}
