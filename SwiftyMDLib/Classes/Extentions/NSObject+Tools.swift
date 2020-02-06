//
//  NSObject+.swift
//  RopeMoney
//
//  Created by Davit Ghushchyan on 9/17/19.
//  Copyright © 2019 RopeMoney. All rights reserved.
//

import UIKit

extension NSObject {

    static var id: String {
        return String(describing: self)
    }
    
    func instantiateController(withIdentifier identifier: String) -> UIViewController? {
        
        var storyBoard : UIStoryboard
        for name in NSObject.arrStoryBoardNames {
            storyBoard = UIStoryboard.init(name: name, bundle: nil)
            if let availableIdentifiers = storyBoard.value(forKey: "identifierToNibNameMap") as? [String: Any] {
                if availableIdentifiers[identifier] != nil {
                    return storyBoard.instantiateViewController(withIdentifier: identifier)
                }
            }
        }
        return nil
    }
    
    func appRootController() ->UIViewController? {
        return NSObject.appRootController()
    }
    
    static func appRootController() ->UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            return rootViewController
        }
        return nil
    }
    
    static func appCurrentController() ->UIViewController? {
        return fetchCurrentController(appRootController())
    }
    
    func appCurrentController() ->UIViewController? {
        return NSObject.appCurrentController()
    }
    
    static func fetchCurrentController(_ rootController : UIViewController?) ->UIViewController? {
        var currentController = rootController
        if let rootController = rootController as? UINavigationController {
            let viewControllers = (rootController).viewControllers
            currentController = viewControllers.last
            currentController = fetchCurrentController(currentController)
        }
        if let rootController = rootController as? UITabBarController {
            currentController = rootController.selectedViewController
            currentController = fetchCurrentController(currentController)
        }
        if ((rootController?.presentedViewController) != nil) {
            currentController = rootController?.presentedViewController
            currentController = fetchCurrentController(currentController)
        }
        
        return currentController
    }
    
     static var arrStoryBoardNames: [String] {
        var arrStoryBoards = [String]()
        let bundleRoot = Bundle.main.bundlePath
        let manager = FileManager.default
        let direnum = manager.enumerator(atPath: bundleRoot)
        
        while let filename:String = direnum?.nextObject() as? String {
            
            //change the suffix to what you are looking for
            if filename.hasSuffix(".storyboardc") {
                
                // Do work here
                print("Files in resource folder" + filename)
                arrStoryBoards.append(filename.lastPathComponent.replacingOccurrences(of: ".storyboardc", with: ""))
                
            }
        }
        if arrStoryBoards.count == 0 {
            arrStoryBoards = [ // Sort a arac @st mtnelu mej@ unecac ejeri qanaki, kam @st im karciqi vor@ hachax kmtnen
                "Main",
                "Dialogs",
                "Notification",
                "Target",
                "Calendar",
                "Stats",
                "Profile",
                "Mailing",
                "Authentication"
            ]
        }
        return arrStoryBoards
    }
}

