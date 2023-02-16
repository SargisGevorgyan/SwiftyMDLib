//
//  UINavigationController+Extension.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 2/16/23.
//

import UIKit

public extension UINavigationController {
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) {
        popToRootViewController(animated: animated)
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }

    func popToViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        popToViewController(viewController, animated: animated)
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
