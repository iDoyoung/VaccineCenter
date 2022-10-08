//
//  RequestProtocol.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import Foundation

enum RequestGenerationError: Error {
    case components
}

protocol Requestable {
    associatedtype Response
    
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HttpMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: String] { get }
    var bodyParameters: [String: Any] { get }
    
    func urlRequest(with networkConfiguration: NetworkAPIConfigurable) throws -> URLRequest
}

extension Requestable {
    func urlRequest(with configuration: NetworkAPIConfigurable) throws -> URLRequest {
        let url = try url(with: configuration)
        var urlRequest = URLRequest(url: url)
        var headers = configuration.headers
        headerParameters.forEach {  headers.updateValue($1, forKey: $0) }
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
    private func url(with configuration: NetworkAPIConfigurable) throws -> URL {
        let baseURL = configuration.baseURL.absoluteString.last != "/" ? configuration.baseURL.absoluteString + "/" : configuration.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw RequestGenerationError.components
        }
        var urlQueryItems = [URLQueryItem]()
        configuration.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = urlQueryItems.isEmpty ? nil : urlQueryItems
        guard let url = urlComponents.url else {
            throw RequestGenerationError.components
        }
        return url
    }
}
