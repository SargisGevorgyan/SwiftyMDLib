//
//  BundleExtension.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
//// MARK: - Notification
public let AppNotificationChangeLanguage = Notification.Name("ChangeLanguage")

private var bundleKey: UInt8 = 0


open class BundleExtension: Bundle {
    
    override open func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

public extension Bundle {
    
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
    
    static func set(language: LanguageEx) {
        Bundle.once
        UserDefaults.standard.set(language.code, forKey: "AppLanguageKey")
        
        
        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            
            print("Failed to get a bundle path.")
            return
        }
                
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NotificationCenter.default.post(name: AppNotificationChangeLanguage, object: nil)
    }
    
    static func currentLanguage() -> LanguageEx {
        var currentLang = UserDefaults.standard.string(forKey: "AppLanguageKey")
        if currentLang == nil {
            let appLang = Bundle.main.preferredLocalizations.first
            UserDefaults.standard.set(LanguageEx(languageCode: appLang)?.code, forKey: "AppLanguageKey")
            currentLang = appLang
        }
        return LanguageEx(languageCode: currentLang) ?? .english
    }
    
    static func checkCurrentLanguageStatus () {
        self .set(language: self.currentLanguage())
    }
}

public extension Locale {
    static var current: Locale? {
        return Locale(identifier: Bundle.currentLanguage().code)
    }
}
