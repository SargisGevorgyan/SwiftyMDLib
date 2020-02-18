//
//  Array+Tools.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        
//        let set = Set(self)
//
//        return (set as! NSSet ).allObjects as? [Element] ?? []
        
        
        return buffer
    }
}
