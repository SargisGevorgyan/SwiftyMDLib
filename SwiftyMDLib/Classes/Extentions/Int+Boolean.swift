//
//  Int+Boolean.swift
//
//  Copyright © 2020 MagicDevs. All rights reserved.
//

import Foundation

extension Int {
    var boolValue: Bool {
        return self == 1 
    }

    mutating func inverseBoolean() {
        self =  boolValue ? 0 : 1
    }
}
