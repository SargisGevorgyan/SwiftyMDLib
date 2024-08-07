//
//  Publisher+Map.swift
//  BestCoachEver
//
//  Created by Sargis Gevorgyan on 12/6/23.
//

import Combine

public extension Publisher {
    func mapTo<Result>(_ value: Result) -> Publishers.Map<Self, Result> {
        map { _ in value }
    }

    func asVoid() -> Publishers.Map<Self, Void> {
        return map { _ in () }
    }
}
