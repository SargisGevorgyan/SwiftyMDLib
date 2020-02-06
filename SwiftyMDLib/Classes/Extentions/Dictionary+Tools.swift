//
//  Dictionary+Tools.swift
//  Dasaran
//
//  Created by Sargis Gevorgyan on 11/6/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

extension Dictionary {
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
