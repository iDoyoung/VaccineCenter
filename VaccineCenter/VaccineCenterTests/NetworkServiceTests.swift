//
//  NetworkServiceTests.swift
//  VaccineCenterTests
//
//  Created by Doyoung on 2022/10/08.
//

import XCTest
@testable import VaccineCenter

class NetworkServiceTest: XCTestCase {
    //MARK: - System Under Test
    var sut: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    //MARK: - Test Doubles
    struct NetworkAPIConfigurableMock: NetworkAPIConfigurable {
        var baseURL: URL = URL(string: "https://mock.test.com")!
        var headers: [String: String] = [:]
        var queryParameters: [String: String] = [:]
    }
    
    struct EndpointMock: Requestable {
        var path: String = ""
        var isFullPath: Bool = false
        var method: HTTPMethodType = .get
        var headerParameters: [String : String] = [:]
        var queryParameters: [String : String] = [:]
        var bodyParameters: [String : Any] = [:]
    }
    enum ErrorMock: Error {
        case someError
    }
    
    struct NetworkSessionDataTaskMock: NetworkSessionDataTaskProtocol {
        let data: Data?
        let response: HTTPURLResponse?
        let error: Error?
        
        func request(_ request: URLRequest, completion: @escaping CompletionHandler) {
            completion(data, response, error)
        }
    }
    
    //MARK: - Tests
    func test_request_whenReceivedResponse_shouldBeSuccess() {
        //given
        let promise = expectation(description: "Be success")
        let configuration = NetworkAPIConfigurableMock()
        let sessionDataTask = NetworkSessionDataTaskMock(data: nil, response: nil, error: nil)
        //when
        sut = NetworkService(configuration: configuration, sessiondatatask: sessionDataTask)
        sut.request(endpoint: EndpointMock()) { result in
            switch result {
            case .success:
                promise.fulfill()
            case .failure:
                XCTFail()
            }
        }
        //then
        wait(for: [promise], timeout: 1)
    }
    func test_request_whenRecivedResponseWithData_shouldBeSuccessAndCorrectData() {
        //given
        let responseData = "Response data".data(using: .utf8)!
        let promise = expectation(description: "Be success and get data")
        let sut = NetworkService(configuration: NetworkAPIConfigurableMock(), sessiondatatask: NetworkSessionDataTaskMock(data: responseData,
                                                                                                                          response: nil,
                                                                                                                          error: nil))
        //when
        sut.request(endpoint: EndpointMock()) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(responseData, data)
                promise.fulfill()
            case .failure:
                XCTFail()
            }
        }
        //then
        wait(for: [promise], timeout: 1)
    }
    func test_request_whenInternetIsNotConnected_shouldBeFailAndNetworkErrorIsNotConnectedInternet() {
        //given
        let promise = expectation(description: "Be Connected Internet Error")
        let networkErrorMock = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet)
        sut = NetworkService(configuration: NetworkAPIConfigurableMock(),
                             sessiondatatask: NetworkSessionDataTaskMock(data: nil,
                                                                         response: nil,
                                                                         error: networkErrorMock as Error))
        //when
        sut.request(endpoint: EndpointMock()) { result in
            do {
                _ = try result.get()
                XCTFail()
            } catch let error {
                guard case NetworkError.notConnectedInternet = error else {
                    XCTFail("Uncorrect Error")
                    return
                }
                promise.fulfill()
            }
        }
        //then
        wait(for: [promise], timeout: 1)
    }
    func test_request_whenBadURL_shouldBeFailAndNetworkErrorIsBadURL() {
        //given
        let promise = expectation(description: "Be Bad URL Error")
        let networkErrorMock = NSError(domain: "network", code: NSURLErrorBadURL)
        sut = NetworkService(configuration: NetworkAPIConfigurableMock(), sessiondatatask: NetworkSessionDataTaskMock(data: nil,
                                                                                                                    response: nil,
                                                                                                                    error: networkErrorMock as Error))
        //when
        sut.request(endpoint: EndpointMock()) { result in
            do {
                _ = try result.get()
            } catch let error {
                guard case NetworkError.badURL = error else {
                    XCTFail("Uncorrect Error")
                    return
                }
                promise.fulfill()
            }
        }
        //then
        wait(for: [promise], timeout: 1)
    }
    func test_request_whenTimeOut_shouldBeFailAndNetworkErrorIsTimeOut() {
        //given
        let promise = expectation(description: "Be Time Out Error")
        let networkErrorMock = NSError(domain: "network", code: NSURLErrorTimedOut)
        sut = NetworkService(configuration: NetworkAPIConfigurableMock(), sessiondatatask: NetworkSessionDataTaskMock(data: nil,
                                                                                                                      response: nil,
                                                                                                                      error: networkErrorMock as Error))
        //when
        sut.request(endpoint: EndpointMock()) { result in
            do {
                _ = try result.get()
            } catch let error {
                guard case NetworkError.timeOut = error else {
                    XCTFail("Uncorrect Error")
                    return
                }
                promise.fulfill()
            }
        }
        //then
        wait(for: [promise], timeout: 1)
    }
    func test_request_whenResponseStatusCodeAbove400_shouldBeFailAndStatusCodeError() {
        //given
        let promise = expectation(description: "Be Status Code Error")
        let responseMock = HTTPURLResponse(url: URL(string: "https://mock.test.com")!,
                                           statusCode: 500,
                                           httpVersion: "1",
                                           headerFields: [:])
        sut = NetworkService(configuration: NetworkAPIConfigurableMock(), sessiondatatask: NetworkSessionDataTaskMock(data: nil,
                                                                                                                      response: responseMock,
                                                                                                                      error: ErrorMock.someError))
        //when
        sut.request(endpoint: EndpointMock()) { result in
            do {
                _ = try result.get()
            } catch let error {
                guard case NetworkError.responseError(let statusCode, _) = error else {
                    XCTFail("Uncorrect Error")
                    return
                }
                XCTAssertEqual(statusCode, 500)
                promise.fulfill()
            }
        }
        //then
        wait(for: [promise], timeout: 1)
    }
}
