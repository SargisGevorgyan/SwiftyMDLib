//
//  Combine+Extension.swift
//  BestCoachEver
//
//  Created by Sargis Gevorgyan on 11/27/23.
//

import Combine

public extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
