//
//  UIDevice+Name.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

public struct ScaleConfigurations {
    public static var defaultConfigs = true
}

public extension UIDevice {
   
    // MARK: DEVOCE MODEL -> Devices
    static var deviceModel: Devices {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return .IPodTouch5
        case "iPod7,1":                                 return .IPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .IPhone4
        case "iPhone4,1":                               return .IPhone4S
        case "iPhone5,1", "iPhone5,2":                  return .IPhone5
        case "iPhone5,3", "iPhone5,4":                  return .IPhone5C
        case "iPhone6,1", "iPhone6,2":                  return .IPhone5S
        case "iPhone7,2":                               return .IPhone6
        case "iPhone7,1":                               return .IPhone6Plus
        case "iPhone8,1":                               return .IPhone6S
        case "iPhone8,2":                               return .IPhone6SPlus
        case "iPhone9,1", "iPhone9,3":                  return .IPhone7
        case "iPhone9,2", "iPhone9,4":                  return .IPhone7Plus
        case "iPhone8,4":                               return .IPhoneSE
        case "iPhone10,1", "iPhone10,4":                return .iPhone8
        case "iPhone10,2", "iPhone10,5":                return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6":                return .iPhoneX
        case "iPhone11,2":                              return .iPhoneXS
        case "iPhone11,4", "iPhone11,6":                return .iPhoneXSMax
        case "iPhone11,8":                              return .iPhoneXR
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .IPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return .IPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return .IPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return .IPadAir
        case "iPad5,3", "iPad5,4":                      return .IPadAir2
        case "iPad6,11", "iPad6,12":                    return .IPad5
        case "iPad7,5", "iPad7,6":                      return .iPad6
        case "iPad2,5", "iPad2,6", "iPad2,7":           return .IPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return .IPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return .IPadMini3
        case "iPad5,1", "iPad5,2":                      return .IPadMini4
        case "iPad6,3", "iPad6,4":                      return .IPadPro9_7
        case "iPad6,7", "iPad6,8":                      return .IPadPro12_9
        case "iPad7,1", "iPad7,2":                      return .IPadPro12_9_Gen2
        case "iPad7,3", "iPad7,4":                      return .IPadPro10_5
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return .IPadPro11
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return .IPadPro12_9_Gen3
        case "AppleTV5,3":                              return .AppleTV
        case "AppleTV6,2":                              return .AppleTV4K
        case "AudioAccessory1,1":                       return .HomePod
        //        case "i386", "x86_64":                          return .Simulator\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
        default:                                        return .Other
        }
    }
    
    // MARK: DEVOCE MODEL NAME -> String
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
    // MARK:  SCREEN SCALE
    static var scale: CGFloat {
        if ScaleConfigurations.defaultConfigs {
            if landscape {
                return UIDevice.isIpad ? 1.84*(screenSize.height / 768) : screenSize.height / 375
            }
            return UIDevice.isIpad ? 1.84*(screenSize.width / 768) : screenSize.width / 375
        } else {
            if landscape {
                return screenSize.height / 375
            }
            return screenSize.width / 375
        }
    }
    
    static var iPadScale: CGFloat {
        if isIpad {
            if landscape {
                return (screenSize.height / 768)
            }
            return (screenSize.width / 768)
        }
        return 1
    }
    
    static var landscape: Bool {
        
        return (screenSize.width > screenSize.height)
    }
    
    // MARK:  SCREEN SIZE
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    // MARK:  SCREEN ISIPAD
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIphone5: Bool {
        if landscape {
            return screenSize.width == 568
        }
        
        return screenSize.height == 568
    }
    
    static var isIphoneX: Bool {
        if landscape {
            return screenSize.width >= 812 && !isIpad
        }
        return screenSize.height >= 812 && !isIpad
    }
}

// MARK: - DEVICES
public enum Devices: String {
    case IPodTouch5
    case IPodTouch6
    case IPhone4
    case IPhone4S
    case IPhone5
    case IPhone5C
    case IPhone5S
    case IPhone6
    case IPhone6Plus
    case IPhone6S
    case IPhone6SPlus
    case IPhoneSE
    case IPhone7
    case IPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhoneSE2
    
    case IPad2
    case IPad3
    case IPad4
    case IPad5
    case iPad6
    case IPadAir
    case IPadAir2
    case IPadMini
    case IPadMini2
    case IPadMini3
    case IPadMini4
    case IPadPro9_7
    case IPadPro12_9
    case IPadPro12_9_Gen2
    case IPadPro10_5
    case IPadPro11
    case IPadPro12_9_Gen3
    
    case AppleTV
    case AppleTV4K
    case HomePod
    case Simulator
    case Other
    
    enum ModelSize {
        case iphone4Size
        case iphone5Size
        case iphone8Size
        case iphoneXSize
        case iphonePlusSize
        case iphoneMaxSize
        case iphoneXRSize
        case iPad
        case iPadProSmall9_7
        case iPadProSmall10_5
        case iPadProBig
        case iPadProGen3
        case iPadMini
        case other
        case simulator
        
    }
    // MARK: - SIZE
    var size: ModelSize {
        switch self {
        case .IPodTouch5,.IPodTouch6 :
            return .other
        case .IPhone4, .IPhone4S:
            return .iphone4Size
        case .IPhone5, .IPhone5C, .IPhone5S, .IPhoneSE:
            return .iphone5Size
        case .IPhone6, .IPhone6S, .IPhone7, .iPhone8, .iPhoneSE2:
            return .iphone8Size
        case .IPhone6Plus, .IPhone6SPlus, .IPhone7Plus, .iPhone8Plus:
            return .iphonePlusSize
            
        case .iPhoneX, .iPhoneXS, .iPhone11Pro:
            return .iphoneXSize
            
        case .iPhoneXSMax, .iPhone11ProMax:
            return .iphoneMaxSize
        case .iPhoneXR, .iPhone11:
            return .iphoneXRSize
        case .IPad2, .IPad3, .IPad4 , .IPad5 , .iPad6, .IPadAir2, .IPadAir:
            return .iPad
            
        case .IPadMini, .IPadMini2, .IPadMini3, .IPadMini4:
            return .iPadMini
        case .IPadPro9_7:
            return .iPadProSmall9_7
        case .IPadPro12_9, .IPadPro12_9_Gen2:
            return .iPadProBig
            
        case .IPadPro10_5:
            return .iPadProSmall10_5;
        case .IPadPro11, .IPadPro12_9_Gen3:
            return .iPadProGen3
            
        case .AppleTV:
            break
        case .AppleTV4K:
            break
        case .HomePod:
            break
        case .Simulator:
            return .simulator
        case .Other:
            break
        }
        return .other
    }
}
