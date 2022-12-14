//
//  Endpoint.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


struct Endpoint<T>: ResponseRequestable {
    typealias Response = T
    
    var path: String
    var isFullPath: Bool
    var method: HTTPMethodType
    var headerParameters: [String : String]
    var queryParameters: [String : String]
    var bodyParameters: [String : Any]
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headerParameters: [String: String] = [:],
         queryParameters: [String: String] = [:],
         bodyParameters: [String: Any] = [:]) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
    }
}
