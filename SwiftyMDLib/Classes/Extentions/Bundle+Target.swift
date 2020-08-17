//
//  Bundle+Target.swift
//  Vain_ios
//
//  Created by Davit Ghushchyan on 4/20/20.
//  Copyright © 2020 MagicDevs. All rights reserved.
//

import Foundation

extension Bundle {

    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    public static func _version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version).\(build)"
    }

    public static var appTarget: String? {
        if let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String {
            return targetName
        }
        return nil
    }
    
    public static var appDisplayName: String {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return ""
    }
}
