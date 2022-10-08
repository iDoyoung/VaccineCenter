//
//  Endpoint.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import Foundation

enum HttpMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


struct Endpoint<T>: Requestable {
    typealias Response = T
    
    var path: String
    var isFullPath: Bool
    var method: HttpMethodType
    var headerParameters: [String : String]
    var queryParameters: [String : String]
    var encodableBodyParameters: Encodable?
    var bodyParameters: [String : Any]
    
}
