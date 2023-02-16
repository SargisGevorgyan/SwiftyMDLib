//
//  Array+Tools.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        
        return buffer
    }
}

public extension Array where Element: Encodable {
    var jsonString: String {
        if let jsonData =  try? JSONEncoder().encode(self) {
            
            let string = String(data: jsonData, encoding: .utf8)
            return string ?? ""
        }
        
        return ""
    }
}

public extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: Hashable {
    func hasAny(_ elements: [Element]) -> Bool {
        return Set(elements).intersection(Set(self)).count > 0
    }
    
    func element(before element: Element) -> Element? {
        guard let index = self.firstIndex(of: element) else { return nil }
        return self[safe: self.index(before: index)]
    }
    
    func element(after element: Element) -> Element? {
        guard let index = self.firstIndex(of: element) else { return nil }
        return self[safe: self.index(after: index)]
    }
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    
    mutating func remove(_ item: Element) {
        if let index = firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

class Box<A> {
    var value: A
    init(_ val: A) {
        self.value = val
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: Box<[Iterator.Element]>] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.value.append(element) {
                categories[key] = Box([element])
            }
        }
        var result: [U: [Iterator.Element]] = Dictionary(minimumCapacity: categories.count)
        for (key, val) in categories {
            result[key] = val.value
        }
        return result
    }
}
