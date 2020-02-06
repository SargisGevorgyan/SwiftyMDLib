//
//  Collections+.swift
//  Dasaran
//
//  Created by Davit Ghushchyan on 11/13/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

extension Array where Element == Double {
    func iscontainOnlyZero() -> Bool {
        for item in self {
            if item != 0 {
                return false
            }
        }
        return true
    }
}

extension Array where Element == Int {
    func iscontainOnlyZero() -> Bool {
        for item in self {
            if item != 0 {
                return false
            }
        }
        return true
    }
}

extension Dictionary where Value == Int {
    func iscontainOnlyZero() -> Bool {
        for item in self.values {
               if item != 0 {
                   return false
               }
           }
           return true
       }
}
extension Dictionary where Value == Double {
    func iscontainOnlyZero() -> Bool {
        for item in self.values {
               if item != 0 {
                   return false
               }
           }
           return true
       }
}
