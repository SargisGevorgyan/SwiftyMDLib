//
//  DownloadRequest.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 2/16/23.
//

import Foundation
import Alamofire

public protocol DownloadRequestable {
    var fileName: String { get }
    var url: String { get }
    var folder: String? { get }
}


public struct MDDownloadResponse {
    public let fileUrl: URL?
}
