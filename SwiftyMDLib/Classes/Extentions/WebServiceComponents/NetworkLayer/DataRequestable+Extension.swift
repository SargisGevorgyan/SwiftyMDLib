//
//  DataRequestable.swift
//  BestCoachEver
//
//  Created by Sargis Gevorgyan on 12/7/23.
//

import SwiftyMDLib
import Combine

public extension DataRequestable {
    static func request<T: Codable>(with endPoint: Endpointable) -> Deferred<Future<T, WebServiceError>> {
        Deferred {
            Future<T, WebServiceError> { promise in
                request(with: endPoint, result: promise)
            }
        }
    }
}
