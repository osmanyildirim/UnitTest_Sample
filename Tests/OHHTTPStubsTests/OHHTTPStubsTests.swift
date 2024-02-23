//
//  OHHTTPStubsTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 23.02.2024.
//

import XCTest
import OHHTTPStubs
@testable import UnitTest_Sample

final class OHHTTPStubsTests: XCTestCase {
    private var mockFilePath: String?
    private var sut: PokemonsRetrievalService?

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockFilePath = OHPathForFile("PokemonsResponseMock.json", type(of: self))
        sut = PokemonsService(networkProvider: NetworkManager())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        HTTPStubs.removeAllStubs()
        mockFilePath = nil
        sut = nil
    }

    @available(iOS 15.0, *)
    func test_givenStubAPI_whenResponseSuccessfull_thenShouldHTTPMethodEqualGET() async {
        let expectation = expectation(description: #function)

        stub(condition: isHost("pokeapi.co") && isPath("/api/v2/pokemon")) { request in
            XCTAssertEqual(request.httpMethod, "GET")
            expectation.fulfill()
            return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
        }

        _ = try? await sut?.getPokemonsWithAsync()

        await fulfillment(of: [expectation])
    }

    func test_givenStubAPIWithDataTaskRequest_whenResponseSuccessfull_thenShouldValidStubbedResponse() async throws {
        guard let mockFilePath else {
            throw CustomError.invalidData
        }

        let expectation = expectation(description: #function)
        var apiResponse: PokemonsResponse?

        stub(condition: isHost("pokeapi.co") && isPath("/api/v2/pokemon")) { _ in
            return HTTPStubsResponse(fileAtPath: mockFilePath,
                                     statusCode: 200,
                                     headers: nil)
        }

        sut?.getPokemonsWithDataTask { [weak self] (result: NetworkResult<PokemonsResponse>) in
            switch result {
            case .success(let response):
                apiResponse = try? XCTUnwrap(response)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])

        let resultsObject = try XCTUnwrap(apiResponse)
        let firstObject = try XCTUnwrap(resultsObject.results.first)

        XCTAssertEqual(resultsObject.results.count, 2)
        XCTAssertEqual(firstObject.name, "bulbasaur")
    }

    func test_givenStubAPIWithDataTaskRequest_whenBadRequest_thenShouldXCTFail() async {
        guard let mockFilePath else { return }

        stub(condition: isHost("pokeapi.co") && isPath("/api/v2/pokemon")) { _ in
            return HTTPStubsResponse(fileAtPath: mockFilePath,
                                     statusCode: 404,
                                     headers: nil)
        }

        sut?.getPokemonsWithDataTask(completion: { (result: NetworkResult<PokemonsResponse>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }

    @available(iOS 15.0, *)
    func test_givenStubAPIWithAsyncRequest_whenResponseSuccessfull_thenShouldValidStubbedResponse() async throws {
        var error: Error?
        var result: NetworkResult<PokemonsResponse>?

        guard let mockFilePath else {
            throw CustomError.invalidData
        }

        stub(condition: isHost("pokeapi.co") && isPath("/api/v2/pokemon")) { _ in
            return fixture(filePath: mockFilePath, status: 200, headers: nil).requestTime(5, responseTime: 5)
        }

        do {
            result = try await sut?.getPokemonsWithAsync()
        } catch let _error {
            error = _error
        }

        let resultsObject = try XCTUnwrap(result?.model)
        let firstObject = try XCTUnwrap(resultsObject.results.first)

        XCTAssertNil(error)
        XCTAssertEqual(result?.model?.results.count, 2)
        XCTAssertEqual(firstObject.name, "bulbasaur")
    }

    @available(iOS 15.0, *)
    func test_givenStubAPIWithAsyncRequestWithTask_whenResponseSuccessfull_thenShouldValidStubbedResponse() async throws {
        guard let mockFilePath else {
            throw CustomError.invalidData
        }

        let expectation = expectation(description: #function)

        stub(condition: isHost("pokeapi.co") && isPath("/api/v2/pokemon")) { _ in
            return HTTPStubsResponse(fileAtPath: mockFilePath,
                                     statusCode: 200,
                                     headers: nil)
        }

        let task = Task {
            let result = try await sut?.getPokemonsWithAsync()
            let resultsObject = try XCTUnwrap(result?.model)
            let firstObject = try XCTUnwrap(resultsObject.results.first)

            XCTAssertEqual(result?.model?.results.count, 2)
            XCTAssertEqual(firstObject.name, "bulbasaur")

            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
        task.cancel()
    }
}
