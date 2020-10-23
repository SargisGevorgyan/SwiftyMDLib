//
//  Language.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

public enum LanguageEx: Int, Equatable,CaseIterable, Codable {
    case english = 0
    case russian = 1
    case armenian = 2
    case chinese = 3
    
    //    func image()-> UIImage {
    //        switch self {
    //        case .armenian: return #imageLiteral(resourceName: "OperaImage")
    //        case .russian: return #imageLiteral(resourceName: "RedSquareImage")
    //        case .english: return #imageLiteral(resourceName: "BigBenImage")
    //        }
    //    }
}


public extension LanguageEx {
    
    var code: String {
        switch self {
            
        case .english:              return "en"
        case .russian:              return "ru"
        case .armenian:             return "hy"
        case .chinese:              return "zh-Hant"
        }
    }
    
    var identifier: String {
        switch self {
            
        case .english:              return "en_US"
        case .russian:              return "ru_RU"
        case .armenian:             return "hy_AM"
        case .chinese:              return "zh_Hant"
        }
    }
    
    var name: String {
        switch self {
            
        case .english:              return "English"
        case .russian:              return "Русский"
        case .armenian:             return "Հայերեն"
        case .chinese:              return "中文"
        }
    }
}

public extension LanguageEx {
    
    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
            
        case "en":              self = .english
        case "ru":              self = .russian
        case "hy":              self = .armenian
        case "zh-Hant":         self = .chinese
        default:                self = .english
        }
    }
}

public extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
