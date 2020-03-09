//
//  Dictionary+Tools.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

public extension Dictionary {
    func allKeys() -> Array<Any> {
        var items = [Any]()
        
        for k in self.keys {
            items.append(k)
        }
        return items
    }
    
    func allValues() -> Array<Any> {
        var items = [Any]()
        
        for v in self.values {
            items.append(v)
        }
        return items
    }
}
