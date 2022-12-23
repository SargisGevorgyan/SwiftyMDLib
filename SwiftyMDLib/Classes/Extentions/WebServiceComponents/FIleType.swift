//
//  FIleType.swift
//  AlamofireNewVersion
//
//  Created by Davit Ghushchyan on 2/2/21.
//

import Foundation

public enum FileType: Codable {

    public enum Video: String, Codable {
        case quickTime = ".mov"
        case mpeg4 = ".mp4"
        case avInterleave = ".avi"

        func mimeType() -> String {
            switch self {
            case .quickTime:
                return "video/quicktime"
            case .mpeg4:
                return "video/mp4"
            case .avInterleave:
                return "video/x-msvideo"
            }
        }
    }
    case photo
    case video(Video)
    case audio
    case doc

    var ext: String {
        switch self {
        case .photo:
            return ".jpg"
        case .video(let type):
            return type.rawValue
        case .audio:
            return ".m4a"
        case .doc:
            return ".pdf"
        }
    }
    
    func mimeType() -> String {
        switch self {
        case .audio:
            return "audio/x-m4a"
        case .video(let type):
            return type.mimeType()
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
