//
//  EndpointType.swift
//  AlamofireNewVersion
//
//  Created by Davit Ghushchyan on 2/2/21.
//

import Foundation
import Alamofire


public struct EndpointDefaultConfigs {
    public static var scheme = "https"
    public static var host = "google.ru"
    public static var isMultyPartByDefault = false
    public static var onTopHeaders: [String:String] = ["os":"iOS", "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? ""]
}

public protocol Endpointable {
    var internetRequired: Bool {get}
    var isMultipart: Bool {get}
    var method: HTTPMethod {get}
    var additionalHeaders: HTTPHeaders {get}
    
    var scheme: String? {get}
    var host: String? {get}
    var path: String {get}
//    var withHeaders: Bool {get}
    var pathParams: [URLQueryItem]? {get}
    var data: Data? {get}
    var files: Files? {get set}
    
    func getUrl()->URL
    func urlRequest(headers: [String:String]) -> URLRequest
    
}

public extension Endpointable {
    var scheme: String? {
        return nil
    }
      var host: String? {
        return nil
    }
     var pathParams: [URLQueryItem]? {
        return nil
    }
     var internetRequired: Bool {
        return true
    }
      var additionalHeaders: HTTPHeaders {
        return HTTPHeaders()
    }
      var isMultipart: Bool {
        return EndpointDefaultConfigs.isMultyPartByDefault
    }
    
      var files: Files? {
        return nil
    }
    
//    var withHeaders: Bool {
//        return true
//    }
    
    func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = scheme ?? EndpointDefaultConfigs.scheme
        components.host = host ?? EndpointDefaultConfigs.host
        components.path = path
        components.queryItems = pathParams
        
        return components.url!
    }
    
    
    func getHeaders(headers: [String:String]) -> [String:String] {
        var dict = [String: String]()
        dict = headers
        dict["Content-Type"] = "application/json"

        for (name, value) in additionalHeaders.dictionary {
            dict[name] = value
        }
        for (name, value) in EndpointDefaultConfigs.onTopHeaders {
            dict[name] = value
        }
        return dict
    }
    
    func urlRequest(headers: [String:String]) -> URLRequest {
        let url = getUrl()
        var request = URLRequest(url: url)
        
        request.httpBody = data
        request.httpMethod = method.rawValue
        request.timeoutInterval = 80

        request.allHTTPHeaderFields = getHeaders(headers: headers)
        
        return request
    }
}
