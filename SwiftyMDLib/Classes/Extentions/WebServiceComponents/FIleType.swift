//
//  FIleType.swift
//  AlamofireNewVersion
//
//  Created by Davit Ghushchyan on 2/2/21.
//

import Foundation

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
    
    public init (type: FileType,key: String?, data: Data, name: String?) {
        self.type = type
        self.data = data
        self.name = name
        self.key = key
    }
}


public struct Files: Codable {
    var key: String
    var files: [File]

    public init (key: String, files: [File]) {
        self.key = key
        self.files = files
    }
    
}
