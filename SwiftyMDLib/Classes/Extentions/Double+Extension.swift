//
//  Double+Extension.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 8/5/20.
//

import Foundation

public extension Double {
    var formattedValue: String {
        return String(format: "%.2f", self)
    }
}

public extension Float {
    var formattedValue: String {
        return String(format: "%.2f", self)
    }
}


public extension String {
    func isDecimal()->Bool{
        
        return self.isValidDecimal(maximumFractionDigits: 2)
    }
}

public extension String {
    
    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    private var decimalSeparator:String {
        return "."
    }
    
    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if self.isNumber {
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.count <= maximumFractionDigits
        }
        
        return false
    }
}

public extension Double {
    var threeDigits: Double {
        return (self * 1000).rounded(.toNearestOrEven) / 1000
    }

    var twoDigits: Double {
        return (self * 100).rounded(.toNearestOrEven) / 100
    }

    var oneDigit: Double {
        return (self * 10).rounded(.toNearestOrEven) / 10
    }
}
