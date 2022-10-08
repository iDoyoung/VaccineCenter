//
//  NetworkService.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import Foundation

enum NetworkError: Error {
    case responseError(statusCode: Int, data: Data?)
    case notConnectedInternet
    case badURL
    case timeOut
    case unexpected(Error)
}

protocol NetworkSessionDataTaskProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func request(_ request: URLRequest, completion: @escaping CompletionHandler)
}

protocol NetworkServiceProtocol {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler)
}

final class NetworkSessionDataTask: NetworkSessionDataTaskProtocol {
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}

final class NetworkService: NetworkServiceProtocol {
    let configuration: NetworkAPIConfigurable
    let sessionDataTask: NetworkSessionDataTaskProtocol
    
    init(configuration: NetworkAPIConfigurable,
         sessiondatatask: NetworkSessionDataTaskProtocol = NetworkSessionDataTask()) {
        self.configuration = configuration
        self.sessionDataTask = sessiondatatask
    }
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
        do {
            let urlReqesut = try endpoint.urlRequest(with: configuration)
            request(request: urlReqesut, completion: completion)
        } catch {
            completion(.failure(.badURL))
        }
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) {
        sessionDataTask.request(request) { [weak self] data, response, reqeustError in
            guard let self = self else { return }
            guard let reqeustError = reqeustError else {
                completion(.success(data))
                return
            }
            var error: NetworkError
            if let response = response as? HTTPURLResponse {
                error = .responseError(statusCode: response.statusCode, data: data)
                #if DEBUG
                print("RESPONSE STATUS CODE: \(response.statusCode)")
                print("RESPONSE : \(String(describing: data))")
                #endif
            } else {
                error = self.resolve(error: reqeustError)
            }
            completion(.failure(error))
        }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let errorCode = URLError.Code(rawValue: (error as NSError).code)
        switch errorCode {
        case .notConnectedToInternet: return .notConnectedInternet
        case .timedOut: return .timeOut
        case .badURL: return .badURL
        default:
            return .unexpected(error)
        }
    }
}
