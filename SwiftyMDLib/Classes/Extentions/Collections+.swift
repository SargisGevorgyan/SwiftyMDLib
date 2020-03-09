//
//  Collections+.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

public extension Array where Element == Double {
    func iscontainOnlyZero() -> Bool {
        for item in self {
            if item != 0 {
                return false
            }
        }
        return true
    }
}

public extension Array where Element == Int {
    func iscontainOnlyZero() -> Bool {
        for item in self {
            if item != 0 {
                return false
            }
        }
        return true
    }
}

public extension Dictionary where Value == Int {
    func iscontainOnlyZero() -> Bool {
        for item in self.values {
               if item != 0 {
                   return false
               }
           }
           return true
       }
}
public extension Dictionary where Value == Double {
    func iscontainOnlyZero() -> Bool {
        for item in self.values {
               if item != 0 {
                   return false
               }
           }
           return true
       }
}
