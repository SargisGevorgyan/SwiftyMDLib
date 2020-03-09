//
//  String+Validation.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

public extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidArmPhone() -> Bool {
        let phoneRegEx = "^(^(91|99|96|43|55|95|41|44|93|94|77|98|49)|^(091|099|096|043|055|095|041|044|093|094|077|098|049))[0-9]{6,6}$"
        
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: self)
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    func tryToCall() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "telprompt://\(self.digits)")!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string: "telprompt://\(self.digits)")!)
        }
    }
    
    func containAnyNumerical() -> Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        return containsNumber
    }
    
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    
}

public extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

public extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
public extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

public extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}

public extension String {
    var intValue: Int {
        return (self as NSString).integerValue
    }
}

public extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }

    func appendingPathComponent(_ string: String) -> String {
        return fileURL.appendingPathComponent(string).path
    }

    var lastPathComponent:String {
        get {
            return fileURL.lastPathComponent
        }
    }

   var deletingPathExtension: String {
    return fileURL.deletingPathExtension().path
   }
}

public extension String {

    /// Returns a string with all non-numeric characters removed
    var numericString: String {
        let characterSet = CharacterSet(charactersIn: "01234567890.").inverted
        return components(separatedBy: characterSet)
            .joined()
    }
    
    /// Returns a string with all non-digit characters removed
    var digitString: String {
        let characterSet = CharacterSet(charactersIn: "01234567890").inverted
        return components(separatedBy: characterSet)
            .joined()
    }
    
    /// Returns a items with all non-digit characters removed
    var digitsItems: [String] {
        let characterSet = CharacterSet(charactersIn: "01234567890").inverted
        return components(separatedBy: characterSet)
    }
    
    /// Returns a items with all digit characters removed
    var withoutDigitsItems: [String] {
        let characterSet = CharacterSet(charactersIn: "01234567890")
        return components(separatedBy: characterSet)
    }
    
    var isValidPassword: Bool {
       return count > 7 && containAnyNumerical()
    }
}
