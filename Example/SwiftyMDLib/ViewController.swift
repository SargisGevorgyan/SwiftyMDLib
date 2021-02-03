//
//  ViewController.swift
//  SwiftyMDLib
//
//  Created by SargisGevorgyan on 01/31/2020.
//  Copyright (c) 2020 SargisGevorgyan. All rights reserved.
//

import UIKit
import SwiftyMDLib
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.prepareReachability()
        MDWebServiceManager.endPoint = "https://jsonplaceholder.typicode.com"
       
        EndpointDefaultConfigs.scheme = "https"
        EndpointDefaultConfigs.host = "jsonplaceholder.typicode.com"
        MDWebServiceManager.getWithUrlRequest("/todos/1", internetRequirement: .required) { (response: Welcome)  in
            
        } failure: { (error) in
            
        }
        NetworkLayer.unAuthorizedHandler = { endpoint in
            
        }
        
        NetworkLayer.noInternetHandler = { endpint in
            
        }
        let endpoint = WelcomeEndpoint()

        NetworkLayer.request(with: endpoint) { (result: Result<Welcome,WebServiceError>) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let image = #imageLiteral(resourceName: "noConnection")
        let jsonData = ["goalID": 0, "type": 0, "main": 1]
        let data =  try? JSONEncoder().encode(jsonData)
      
        var uploadEndpoint = UploadImageEndpoint()
        let file = File(type: .photo, key: "image", data: image.pngData() ?? Data(), name: "image")
        
        
        uploadEndpoint.files = Files(key: "image", files: [file])
        uploadEndpoint.data = data
        
        NetworkLayer.request(with: uploadEndpoint) { (result: Result<Welcome, WebServiceError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
            }
        }
    }

}

struct Welcome: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

struct WelcomeEndpoint: Endpointable {
    var files: Files? = nil
    
    var data: Data? = nil
    
    var method: HTTPMethod = .get
    var path: String = "/todos/1"
}

//http://www.bluger.ch/envision/api_v2_8/add_vision_image
struct UploadImageEndpoint: Endpointable {
    var files: Files? = nil
    
    var data: Data? = nil
    var isMultipart: Bool = true
    
    var method: HTTPMethod = .post
    var host: String? = "www.bluger.ch"
    var path: String = "/envision/api_v2_8/add_vision_image"
    var additionalHeaders: HTTPHeaders = .init(["Api-Token"  : "4c809012d7a0e134c02cb1d60bd981d9"])
}
