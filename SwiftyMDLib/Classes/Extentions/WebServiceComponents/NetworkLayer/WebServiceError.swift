//
//  WebServiceError.swift
//  AlamofireNewVersion
//
//  Created by Davit Ghushchyan on 2/2/21.
//

import Foundation
import Alamofire

public enum WebServiceError: Error {
    case noInternet(endPoint: Endpointable)
    case serverError(statusCode: HTTPStatusCode, body: Data?, response: HTTPURLResponse)
    case clientError(statusCode: HTTPStatusCode, body: Data?, response: HTTPURLResponse)
    case undefined(statusCode: HTTPStatusCode, body: Data?, response: HTTPURLResponse)
    case dataParsing(error: Error)
    case message(message: String)
    case noStatusCode
}


