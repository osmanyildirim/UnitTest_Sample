//
//  NetworkManagerTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 13.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class NetworkManagerTests: XCTestCase {
    private var mockResponseData: Data?
    private var api: APIs?
    private var urlSession: URLSession?
    private var sut: NetworkProvider?

    override func setUpWithError() throws {
        try super.setUpWithError()

        urlSession = URLSession.mock
        api = APIs.pokemons

        guard let urlSession else { return }
        sut = NetworkManager(session: urlSession)

        mockResponseData = ResourceManager.jsonData(fileName: "PokemonsResponseMock", fileType: .json)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        mockResponseData = nil
        api = nil
        urlSession = nil
        sut = nil
    }

    @available(iOS 15.0, *)
    func test_givenAsyncRequest_whenResponseSuccessfull_thenShouldValidResponse() async throws {
        guard let sut, let api else {
            throw CustomError.requestFailed
        }

        MockURLProtocol.requestHandler = { request in
            guard let url = api.url, request.url == url else {
                throw CustomError.invalidURL
            }

            guard let mockResponseData = self.mockResponseData else {
                throw CustomError.invalidData
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockResponseData, response)
        }

        let result: NetworkResult<PokemonsResponse> = try await sut.requestAsync(api)
        let resultsObject = try XCTUnwrap(result.model)
        let firstObject = try XCTUnwrap(resultsObject.results.first)

        XCTAssertEqual(firstObject.name, "bulbasaur")
    }

    @available(iOS 15.0, *)
    func test_givenAsyncRequestWithTask_whenResponseSuccessfull_thenShouldValidResponse() async throws {
        guard let sut, let api else {
            throw CustomError.requestFailed
        }

        let expectation = XCTestExpectation(description: #function)

        MockURLProtocol.requestHandler = { request in
            guard let url = api.url, request.url == url else {
                throw CustomError.invalidURL
            }

            guard let mockResponseData = self.mockResponseData else {
                throw CustomError.invalidData
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockResponseData, response)
        }

        let task = Task {
            let result: NetworkResult<PokemonsResponse> = try await sut.requestAsync(api)
            let resultsObject = try XCTUnwrap(result.model)
            let firstObject = try XCTUnwrap(resultsObject.results.first)

            XCTAssertEqual(firstObject.name, "bulbasaur")

            expectation.fulfill()
        }

        await fulfillment(of: [expectation])
        task.cancel()
    }

    func test_givenDataTaskRequest_whenResponseSuccessfull_thenShouldValidResponse() throws {
        guard let sut, let api else {
            throw CustomError.requestFailed
        }

        let expectation = XCTestExpectation(description: #function)

        MockURLProtocol.requestHandler = { request in
            guard let url = api.url, request.url == url else {
                throw CustomError.invalidURL
            }

            guard let mockResponseData = self.mockResponseData else {
                throw CustomError.invalidData
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockResponseData, response)
        }

        _ = sut.request(api) { [weak self] (result: NetworkResult<PokemonsResponse>) in
            switch result {
            case .success(let response):
                let firstObject = try? XCTUnwrap(response.results.first)

                XCTAssertEqual(firstObject?.name, "bulbasaur")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }

        wait(for: [expectation])
    }
}

private extension URLSession {
    static var mock: URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
