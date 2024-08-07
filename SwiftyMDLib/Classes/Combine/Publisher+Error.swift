//
//  Publisher+Error.swift
//  BestCoachEver
//
//  Created by Sargis Gevorgyan on 12/7/23.
//

import Combine

public extension Publisher {
    func forwardError<Root: AnyObject>(to error: ReferenceWritableKeyPath<Root, Failure?>, on object: Root) -> Publishers.IgnoreErrors<Publishers.HandleEvents<Self>> {
        handleEvents(receiveCompletion: { [weak object] completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                object?[keyPath: error] = failure
            }
        }).ignoreErrors()
    }

    func forwardError2<Root: AnyObject>(to error: ReferenceWritableKeyPath<Root, WebServiceError?>, on object: Root) -> Publishers.IgnoreErrors<Publishers.HandleEvents<Self>> {
        handleEvents(receiveCompletion: { [weak object] completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                object?[keyPath: error] = failure as? WebServiceError
            }
        }).ignoreErrors()
    }
}


public extension Publishers {
    struct IgnoreErrors<Upstream: Publisher>: Publisher {
        public typealias Output = Upstream.Output
        public typealias Failure = Never
        let upstream: Upstream

        public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            upstream
                .map { $0 }
                .replaceError(with: nil)
                .unwrap()
                .subscribe(subscriber)
        }
    }
}

public extension Publisher {
    func ignoreErrors() -> Publishers.IgnoreErrors<Self> {
        Publishers.IgnoreErrors(upstream: self)
    }
}

public extension Publishers {
    struct Unwrap<Upstream: Publisher, Output>: Publisher where Upstream.Output == Output? {
        public typealias Failure = Upstream.Failure
        let upstream: Upstream

        public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            upstream
                .compactMap { $0 }
                .subscribe(subscriber)
        }
    }
}

public extension Publisher {
    public func unwrap<T>() -> Publishers.Unwrap<Self, T> {
        Publishers.Unwrap(upstream: self)
    }
}
