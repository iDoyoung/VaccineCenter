//
//  NetworkDataTransferService.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import Foundation
import RxSwift

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
}

protocol NetworkDataTransferServiceProtocol {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> Observable<T> where E.Response == T
    func request<E>(with endpoint: E) -> Observable<Data?> where E: Requestable
}

final class NetworkDataTransferService: NetworkDataTransferServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private var disposeBag = DisposeBag()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> Observable<T> where E.Response == T {
        return Observable<Data?>.create { [weak self] observer in
            if let self = self {
                self.networkService.request(endpoint: endpoint) { result in
                    switch result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        observer.onError(DataTransferError.networkFailure(error))
                    }
                }
            }
            return Disposables.create()
        }.map { data in
            do {
                let result: T = try self.decode(data: data)
                return result
            } catch let error {
                throw DataTransferError.parsing(error)
            }
        }
    }
    
    func request<E>(with endpoint: E) -> Observable<Data?> where E: Requestable {
        return Observable<Data?>.create { [weak self] observer in
            self?.networkService.request(endpoint: endpoint) { result in
                switch result {
                case .success(let data):
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    private func decode<T: Decodable>(data: Data?) throws -> T {
        do {
            guard let data = data else {
                throw DataTransferError.noResponse
            }
            let result: T = try JSONResponseDecoder().decode(data)
            return result
        } catch {
            throw DataTransferError.parsing(error)
        }
    }
}

final class JSONResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
