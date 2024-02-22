//
//  NetworkLayer.swift
//
//

import Foundation
import Alamofire


public protocol DataRequestable {
    static func request<T: Decodable>(with endPoint: Endpointable, result: @escaping (Result<T, WebServiceError>)->())
    static func download(item: DownloadRequestable, result: @escaping (Result<MDDownloadResponse, WebServiceError>) -> Void)
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
                        if let val = try? JSONSerialization.jsonObject(with: respData),
                            let jsonData = try? JSONSerialization.data(withJSONObject: val, options: .prettyPrinted) {
                            data = jsonData
                        }
                    }
                }
                let decoder = JSONDecoder()
                do {
                    let reqJSONStr = String(data: data!, encoding: .utf8)
                    print("From Request: ", endPoint.getUrl().absoluteURL)
                    print("Response: ", reqJSONStr ?? "")
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

    private static func processDownloadData(response: AFDownloadResponse<URL?>, result: @escaping (Result<MDDownloadResponse, WebServiceError>) -> Void) {
        let statusCode = response.response?.status
        guard let responseType = response.response?.status?.responseType else {
            result(.failure(.noStatusCode))
            return
        }
        let httpResponse = response.response!

        switch responseType {
        case .serverError:
            result(.failure(.serverError(statusCode: statusCode! , body: response.resumeData, response: httpResponse)))
        case .informational:
            result(.failure(.noStatusCode))
        case .success, .redirection:
            switch response.result {
            case .success:
                result(.success(MDDownloadResponse(fileUrl: response.fileURL)))

            case .failure(let error):
                result(.failure(.dataParsing(error: error)))
            }
        case .clientError:
            result(.failure(.clientError(statusCode: statusCode!, body: response.resumeData, response: httpResponse)))
        case .undefined:
            result(.failure(.undefined(statusCode: statusCode!, body: response.resumeData, response: httpResponse)))
        }
    }

    private static func regularRequest<T>(with endPoint: Endpointable, result: @escaping (Result<T, WebServiceError>) -> ()) where T : Decodable {
        let request = endPoint.urlRequest(headers: [:])
        if endPoint.useAF {
            AF.request(request).responseJSON { (response: DataResponse<Any,AFError>) in
                processData(with: endPoint, response: response, result: result)
            }
        } else {
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                let afResult = AFResult<Any>(value: data, error: error?.asAFError)
                let resp = AFDataResponse<Any>(request: request, response: response as? HTTPURLResponse, data: data, metrics: nil, serializationDuration: 0, result: afResult)

                DispatchQueue.main.async {
                    processData(with: endPoint, response: resp, result: result)
                }

            }.resume()
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
                    name += file.type.ext
                    var currentName =  isSingleObject ? file.key : "\(files!.key)[\(i)]"
                    if let key = file.key {
                        currentName = key
                    }
                    multipartFormData.append(data, withName: currentName ?? "", fileName: name, mimeType: file.type.mimeType()) //image/jpg ,application/pdf, audio/x-m4a,video/quicktime
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

    public static func download(item: DownloadRequestable, result: @escaping (Result<MDDownloadResponse, WebServiceError>) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            if let folder = item.folder {
                if #available(iOS 14.0, *) {
                    documentsURL = documentsURL.appendingPathComponent(folder, conformingTo: .folder)
                } else {
                    documentsURL = documentsURL.appendingPathComponent(folder)
                }
            }
            let fileURL = documentsURL.appendingPathComponent(item.fileName)

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(item.url, to: destination).response { response in
            self.processDownloadData(response: response, result: result)
        }
    }
}

extension Result {
    /// Returns whether the instance is `.success`.
    var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }

    /// Returns whether the instance is `.failure`.
    var isFailure: Bool {
        !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }

    /// Initializes a `Result` from value or error. Returns `.failure` if the error is non-nil, `.success` otherwise.
    ///
    /// - Parameters:
    ///   - value: A value.
    ///   - error: An `Error`.
    init(value: Success, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .success(value)
        }
    }

    /// Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `tryMap` method with a closure that may throw an error. For example:
    ///
    ///     let possibleData: Result<Data, Error> = .success(Data(...))
    ///     let possibleObject = possibleData.tryMap {
    ///         try JSONSerialization.jsonObject(with: $0)
    ///     }
    ///
    /// - parameter transform: A closure that takes the success value of the instance.
    ///
    /// - returns: A `Result` containing the result of the given closure. If this instance is a failure, returns the
    ///            same failure.
    func tryMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        switch self {
        case let .success(value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(error)
            }
        case let .failure(error):
            return .failure(error)
        }
    }

    /// Evaluates the specified closure when the `Result` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `tryMapError` function with a closure that may throw an error. For example:
    ///
    ///     let possibleData: Result<Data, Error> = .success(Data(...))
    ///     let possibleObject = possibleData.tryMapError {
    ///         try someFailableFunction(taking: $0)
    ///     }
    ///
    /// - Parameter transform: A throwing closure that takes the error of the instance.
    ///
    /// - Returns: A `Result` instance containing the result of the transform. If this instance is a success, returns
    ///            the same success.
    func tryMapError<NewFailure: Error>(_ transform: (Failure) throws -> NewFailure) -> Result<Success, Error> {
        switch self {
        case let .failure(error):
            do {
                return try .failure(transform(error))
            } catch {
                return .failure(error)
            }
        case let .success(value):
            return .success(value)
        }
    }
}
