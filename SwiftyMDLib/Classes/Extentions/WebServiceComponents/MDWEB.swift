
import UIKit
import Alamofire

// MARK: - FILETYPE
public enum FileType:String , Codable {
    case photo = ".jpg"
    case video = ".mov"
    case audio = ".m4a"
    case doc = ".pdf"
    
    func mineType() -> String {
        switch self {
        case .audio:
            return "audio/x-m4a"
        case .video:
            return "video/quicktime"
        case .photo:
            return "image/jpeg"
        case .doc:
            return "application/pdf"
        }
    }
}

public struct File: Codable {
    public var type: FileType
    public var data: Data
    public  var name: String?
    public var key: String?
    
    public init (type: FileType, data: Data, name: String?) {
        self.type = type
        self.data = data
        self.name = name
    }
}


open class MDWebServiceManager {
    public enum InternetRequirementState {
        case required
        case nonessential
        case byDefault
    }
    
    public static var tokenHeaderKey: String = "X-AUTH-TOKEN"
    public static var token = String()
    public static var endPoint = "www.google.com"
    
    static let sessionManager = Alamofire.SessionManager.default
    
    // MARK: - GET HEADERS
    open class func getHeader() -> HTTPHeaders? {
        if !token.isEmpty {
            return [MDWebServiceManager.tokenHeaderKey: token]
        }
        return nil
    }
    // MARK: - GET SOCKET
    open class func getSocketHeader() -> HTTPHeaders? {
        if !token.isEmpty {
            return [MDWebServiceManager.tokenHeaderKey: token]
        }
        return nil
    }
    
    open class func stopAllRequests() {
        sessionManager.session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
        
    }
    
    // MARK: - GENEARL REQUEST METHOD
    open class func request<T : Codable>(_ str: String,
                                         method: HTTPMethod,
                                         params: Data?,
                                         withHeader: Bool = true,
                                         view: UIView? = nil,
                                         color: UIColor = .white,
                                         withLoading: Bool = true,
                                         encoding: ParameterEncoding,
                                         headers: HTTPHeaders?,
                                         internetRequirement: InternetRequirementState,
                                         success:@escaping (T) -> Void,
                                         failure:@escaping (String) -> Void) {
        let urlString = endPoint + str
        print(urlString + " Was Called at: \(Date().description)")
        let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: escapedAddress!)!)
        request.httpBody = params
        request.httpMethod = method.rawValue
        request.timeoutInterval = 80
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if withHeader {
            request.allHTTPHeaderFields = getHeader()
        }
        //        if let lang = LanguageManger.shared.currentLanguage?.rawValue {
        //            request.allHTTPHeaderFields = ["languageCode": lang]
        //        }
        request.allHTTPHeaderFields = ["os": "ios",
                                       "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "",
                                       "MobileModel": UIDevice.modelName]
        
//        UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
        
        if withLoading {
            if view == nil {
                Loading.showLoadingOnWindow()
            } else {
                Loading.showLoading(view!, color)
            }
        }
        
        sessionManager.request(request).validate().responseJSON { (response) in
            
            func openNoInternet()-> Bool {
                guard (Network.reachability?.isConnectedToNetwork ?? false || Network.reachability == nil) else {
                    noInternetHandler(url:str) {
                        MDWebServiceManager.request(str, method: method, params: params, encoding: encoding, headers: headers, internetRequirement: internetRequirement, success: success, failure: failure)
                    }
                    return true
                }
                return false
            }
            
            
            if withLoading {
                Loading.hideLoadingOnWindow()
            }
            if openNoInternet() {
                return
            }
            
            
            if response.result.isSuccess {
                if response.result.value is [String : Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response.result.value as! [String : Any], options: .prettyPrinted)
                        let reqJSONStr = String(data: jsonData, encoding: .utf8)
                        print(reqJSONStr ?? "")
                        let data = reqJSONStr?.data(using: .utf8)
                        let jsonDecoder = JSONDecoder()
                        let responseData = try jsonDecoder.decode(T.self, from: data!)
                        
                        
                        success(responseData)
                        print(responseData)
                    } catch {
                        print(error)
                        failure(error.localizedDescription)
                    }
                }
            }
            
            if response.result.error != nil {
                
                switch response.response?.statusCode ?? 0 {
                case 401:
                    unAuthorizedHandler(response)
                    failure(NSLocalizedString("title_please_signIn", comment: ""))
                    print("Tried to Sign Out")
                    return
                case 402...404, 500...506:
                    somethingWentWrongHandler(response) {}
                    failure(NSLocalizedString("Sorry something went wrong, please try again", comment: ""))
                    return
                //                        return
                default:
                    break
                }
                
                if response.response?.statusCode == 401 {
                    
                } else {
                    if view == nil {
                        
                        //                        failure(ErrorType.servererror.rawValue)
                    }
                }
            } else if let x  = (response.response?.statusCode) {
                if x > 403 {
                    failure(String(x))
                }
            }
        }
    }
    
    // MARK: - GET WITH URLREQUEST
    open class func getWithUrlRequest<T : Codable>(_ method: String,
                                                   urlParams: String = "",
                                                   withLoading: Bool = true,
                                                   internetRequirement: InternetRequirementState,
                                                   success:@escaping (T) -> Void,
                                                   failure:@escaping (String) -> Void) {
        let urlpath = method + urlParams
        request(urlpath,
                method: .get,
                params: nil,
                withLoading: withLoading,
                encoding: JSONEncoding.default,
                headers: getHeader(),
                internetRequirement: internetRequirement,
                success: { (response) in
                    success(response)
        }, failure: {(error) in
            failure(error)
        })
    }
    // MARK: - GET WITH URLREQUEST WITHOUT HEADERS
    open class func getWithUrlRequestWithoutHeader<T : Codable>(_ method: String,
                                                                urlParams: String = "",
                                                                view: UIView? = nil,
                                                                color: UIColor = .white,
                                                                withLoading: Bool = true,
                                                                internetRequirement: InternetRequirementState,
                                                                success:@escaping (T) -> Void,
                                                                failure:@escaping (String) -> Void) {
        
        let urlpath = method + urlParams
        
        request(urlpath,
                method: .get,
                params: nil,
                view: view,
                color: color,
                withLoading: withLoading,
                encoding: JSONEncoding.default,
                headers: nil,
                internetRequirement: internetRequirement,
                success: { (response) in
                    success(response)
        }, failure: {(error) in
            failure(error)
        })
    }
    
    // MARK: - PUT HEADER AND PARAMS
    open class func putRequestWithHeaderAndParams<T: Codable>(_ method: String,
                                                              model jsonData : Data?,
                                                              view: UIView? = nil,
                                                              color: UIColor = .white,
                                                              withLoading: Bool = true,
                                                              internetRequirement: InternetRequirementState,
                                                              success:@escaping (T) -> Void,
                                                              failure:@escaping (String) -> Void) {
        
        request(method,
                method: .put,
                params: jsonData,
                view: view,
                color: color,
                withLoading: withLoading,
                encoding: URLEncoding.httpBody,
                headers: getHeader(),
                internetRequirement: internetRequirement,
                success: { (response) in
                    success(response)
        }, failure: {(error) in
            failure(error)
        })
    }
    
    // MARK: - POST
    open class func postRequest<T: Codable>(_ method: String,
                                            model jsonData : Data?,
                                            withHeader: Bool = true,
                                            view: UIView? = nil,
                                            color: UIColor = .white,
                                            withLoading: Bool = true,
                                            internetRequirement: InternetRequirementState,
                                            success:@escaping (T) -> Void,
                                            failure:@escaping (String) -> Void) {
        
        
        request(method,
                method: .post,
                params: jsonData,
                withHeader: withHeader,
                view: view,
                color: color,
                withLoading: withLoading,
                encoding: JSONEncoding.default,
                headers: nil,
                internetRequirement: internetRequirement,
                success: { (response) in
                    success(response)
        }, failure: {(error) in
            failure(error)
        })
    }
    // MARK: - DELETE
    open class func deleteRequest<T: Codable>(_ method: String,
                                              withLoading: Bool = true,
                                              model jsonData: Data?,
                                              internetRequirement: InternetRequirementState,
                                              success:@escaping (T) -> Void,
                                              failure:@escaping (String) -> Void) {
        
        
        
        request(method,
                method: .delete,
                params: jsonData,
                withLoading: withLoading,
                encoding: JSONEncoding.default,
                headers: getHeader(),
                internetRequirement: internetRequirement,
                success: { (response) in
                    success(response)
        }, failure: {(error) in
            failure(error)
        })
    }
    
    
    // MARK: - MULTYPART
    open class func multypartRequest<T: Codable> (_ strURL: String,
                                                  params: Data?,
                                                  isSingleObject: Bool = true,
                                                  method: HTTPMethod = .post,
                                                  withLoading: Bool = true,
                                                  view: UIView? = nil,
                                                  color: UIColor = .systemGray,
                                                  files: [File],
                                                  fieldName: String,
                                                  internetRequirement: InternetRequirementState = .byDefault,
                                                  success:@escaping (T) -> Void,
                                                  failure:@escaping (String) -> Void) {
        
        let url = endPoint + strURL
        
        print("___ Request SEnt to : \(url) at: \(Date())")
        
        
        
        func openNoInternet()-> Bool {
            guard (Network.reachability?.isConnectedToNetwork ?? false || Network.reachability == nil) else {
                //                failure(NSLocalizedString(ErrorType.nointernet.rawValue, comment: ""))
                noInternetHandler(url: strURL) {
                    MDWebServiceManager.multypartRequest(strURL, params: params, isSingleObject: isSingleObject, method: method, withLoading: withLoading, view: view, color: color, files: files, fieldName: fieldName, internetRequirement: internetRequirement, success: success, failure: failure)
                }
                return true
            }
            return false
        }
        
        func openServerError(_ response: DataResponse<Any>?) {
            somethingWentWrongHandler(response) {
                MDWebServiceManager.multypartRequest(strURL, params: params, isSingleObject: isSingleObject, method: method, withLoading: withLoading, view: view, color: color, files: files, fieldName: fieldName, internetRequirement: internetRequirement, success: success, failure: failure)
            }
        }
        
        if openNoInternet() {
            return
        }
        
        
        func attachMultiPartFormData(files: [File?], fieldName: String ,multipartFormData: MultipartFormData) {
            var i = 0
            for file in files {
                let fileSize = file?.data.count ?? 0
                if fileSize != 0 {
                    if let data = file?.data {
                        var name = file?.name ?? UUID().uuidString
                        name += file?.type.rawValue ?? ""
                        
                        var currentName =  isSingleObject ? fieldName : "\(fieldName)[\(i)][file]"
                        if let key = file?.key {
                            currentName = key
                        }
                        multipartFormData.append(data, withName: currentName, fileName: name, mimeType: file?.type.mineType() ?? "") //image/jpg ,application/pdf, audio/x-m4a,video/quicktime
                        i += 1
                    }
                }
            }
        }
        
//        UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
        
        let jsonParams  = ((try? JSONSerialization.jsonObject(with: params ?? Data(), options: .allowFragments) as? [String: Any]) as [String : Any]??)
        if withLoading {
            if view == nil {
                Loading.showLoadingOnWindow()
            } else {
                Loading.showLoading(view!, color)
            }
        }
        
        sessionManager.upload(multipartFormData: { (multipartFormData) in //Attach parameters
            if let jsonParams = jsonParams {
                for (key, value) in jsonParams ?? [:] {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            attachMultiPartFormData(files: files, fieldName: fieldName, multipartFormData: multipartFormData)
            
        }, to: url, method: method, headers: getHeader()) { (result) in
            
            
            switch result {
            case .success(let upload, _,_ ):
                upload.responseJSON { response in
                    
                    if withLoading {
                        Loading.hideLoadingOnWindow()
                    }
                    
                    print(response)
                    
                    let statusCode = response.response?.statusCode ?? 0
                    if  statusCode == 500 {
                        openServerError(response)
                    }
                    switch  statusCode {
                        
                    case 401:
                        unAuthorizedHandler(response)
                        failure(NSLocalizedString("title_please_signIn", comment: ""))
                        print("Tried to Sign Out")
                        return
                    case 402...499, 500...506:
                        openServerError(response)
                    failure(NSLocalizedString("Sorry something went wrong, please try again", comment: ""))
                        return
                    default:
                        break
                    }
                    
                    func resonseJsonData() ->Data? {
                        do {
                            guard let value = response.result.value else {
                                return nil
                            }
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            
                            return jsonData
                        } catch {
                            return nil
                        }
                    }
                    guard let jsonData = resonseJsonData() else {
                        return
                    }
                    do {
                        let jsonDecoder = JSONDecoder()
                        let reqJSONStr = String(data: jsonData, encoding: .utf8)
                        print(reqJSONStr ?? "")
                        let data = reqJSONStr?.data(using: .utf8)
                        let responseData = try jsonDecoder.decode(T.self, from: data!)
                        
                        success(responseData)
                    } catch {
                        print(error)
                        openServerError(response)
                        
                        do {
                            let jsonDict = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String: Any]
                            
                            if let msg = (jsonDict)?["msg"]  as? String {
                                failure(msg)
                                return
                            }
                            failure("")
                        }
                    }
                    
                    
                    
                    if let err = response.error {
                        openServerError(response)
                        failure(err.localizedDescription)
                        return
                    }
                }
            case .failure(let error):
                openServerError(nil)
                print("Error in upload: \(error.localizedDescription)")
                failure(error.localizedDescription)
            }
            
        }
    }
    
    open class func unAuthorizedHandler(_ response: DataResponse<Any>?) {
        
    }
    
    open class func noInternetHandler(url: String, _ completion: @escaping ()->()) {
        NotificationCenter.default.post(name: noInternetNotification , object: ["completion": completion, "url":url])
    }
    
    open class func somethingWentWrongHandler(_ response: DataResponse<Any>?, _ completion: @escaping ()->()) {
        
    }
    public static let noInternetNotification = Notification.Name(rawValue:"No internet")
}



