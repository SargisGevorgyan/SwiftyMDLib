//
//  NetworkLayer.swift
//  AlamofireNewVersion
//
//  Created by Davit Ghushchyan on 2/2/21.
//

import Foundation
import Alamofire


public protocol DataRequestable {
    static func request<T: Decodable>(with endPoint: Endpointable, result: @escaping (Result<T, WebServiceError>)->())
    static var noInternetHandler: ((Endpointable)->() )? { get set }
    static var unAuthorizedHandler: ((Endpointable)->() )? { get set }
    
    static func stopAllRequests()
}


public class NetworkLayer: DataRequestable {
    public static var unAuthorizedHandler: ((Endpointable) -> ())?
    public static var noInternetHandler: ((Endpointable) -> ())?
    
    public static func stopAllRequests() {
        AF.cancelAllRequests()
    }
    
    public  static func request<T>(with endPoint: Endpointable, result: @escaping (Result<T, WebServiceError>) -> ()) where T : Decodable {
        if endPoint.internetRequired {
            if !(Network.reachability?.isConnectedToNetwork ?? false) {
                result(.failure(.noInternet(endPoint: endPoint)))
                noInternetHandler?(endPoint)
                return
            }
        }
        print("___ Request Sent to : \(endPoint.getUrl().absoluteString) at: \(Date())")
        if endPoint.isMultipart {
            multipartRequest(with: endPoint,result: result)
        } else {
            regularRequest(with: endPoint, result: result)
        }
    }
    
    
    private static func processData<T>(with endPoint: Endpointable, response: AFDataResponse<Any>, result: @escaping (Result<T, WebServiceError>) -> ()) where T : Decodable {
        let statusCode = response.response?.status
        guard let responseType = response.response?.status?.responseType else {
            result(.failure(.noStatusCode))
            return
        }
        let httpResponse = response.response!
        
        
        switch responseType {
        case .serverError:
            result(.failure(.serverError(statusCode: statusCode! , body: response.data, response: httpResponse)))
        case .informational:
            result(.failure(.noStatusCode))
        case .success, .redirection:
            switch response.result {
            case .success(let value):
                var data: Data?
                
                if let value = value as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        data = jsonData
                    } catch {
                        result(.failure(.dataParsing(error: error)))
                    }
                } else {
                    if let respData = response.data {
                        data = respData
                    }
                }
                let decoder = JSONDecoder()
                do {
                    let reqJSONStr = String(data: data!, encoding: .utf8)
                    print(reqJSONStr ?? "")
                    let responseData = try decoder.decode(T.self, from: data!)
                    result(.success(responseData))
                } catch {
                    
                    result(.failure(.dataParsing(error: error)))
                    print("Can't decode ", error.localizedDescription)
                }
                
            case .failure(let error):
                result(.failure(.dataParsing(error: error)))
            }
        case .clientError:
            if statusCode! == .unauthorized {
                unAuthorizedHandler?(endPoint)
            }
            result(.failure(.clientError(statusCode: statusCode!, body: response.data, response: httpResponse)))
        case .undefined:
            result(.failure(.undefined(statusCode: statusCode!, body: response.data, response: httpResponse)))
        }
    }
    
    private static func regularRequest<T>(with endPoint: Endpointable, result: @escaping (Result<T, WebServiceError>) -> ()) where T : Decodable {
        let request = endPoint.urlRequest(headers: [:])
        
        AF.request(request).responseJSON { (response: DataResponse<Any,AFError>) in
            processData(with: endPoint, response: response, result: result)
        }
    }
    
    
    private static func multipartRequest<T>(with endPoint: Endpointable, result: @escaping (Result<T, WebServiceError>) -> ()) where T : Decodable {
        let jsonParams  = try? JSONSerialization.jsonObject(with: endPoint.data ?? Data(), options: .allowFragments) as? [String: Any]
        func attachMultiPartFormData(files: Files? ,multipartFormData: MultipartFormData) {
            var i = 0
            let isSingleObject = files?.files.count == 1
            for file in files?.files ?? [] {
                let fileSize = file.data.count
                if fileSize != 0 {
                    let data = file.data
                    var name = file.name ?? UUID().uuidString
                    name += file.type.rawValue
                    var currentName =  isSingleObject ? file.key : "\(files!.key)[\(i)]"
                    if let key = file.key {
                        currentName = key
                    }
                    multipartFormData.append(data, withName: currentName ?? "", fileName: name, mimeType: file.type.mineType()) //image/jpg ,application/pdf, audio/x-m4a,video/quicktime
                    i += 1
                }
            }
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in jsonParams ?? [:] {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            attachMultiPartFormData(files: endPoint.files, multipartFormData: multipartFormData)
        }, with: endPoint.urlRequest(headers: [:])).responseJSON { (response) in
            processData(with: endPoint, response: response, result: result)
        }
    }
    
    
}




