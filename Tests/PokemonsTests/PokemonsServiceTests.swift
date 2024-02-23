//
//  PokemonsServiceTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 14.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class PokemonsServiceTests: XCTestCase {
    private var pokemonsService: PokemonsService?

    override func setUpWithError() throws {
        try super.setUpWithError()

        pokemonsService = PokemonsService(networkProvider: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        pokemonsService = nil
    }

    @available(iOS 15.0, *)
    func test_givenPokemonsWithAsyncRequest_whenResponseSuccessfull_thenShouldValidResponse() async throws {
        let result = try await pokemonsService?.getPokemonsWithAsync()
        let resultsObject = try XCTUnwrap(result?.model)
        let firstObject = try XCTUnwrap(resultsObject.results.first)

        XCTAssertEqual(firstObject.name, "bulbasaur")
    }

    @available(iOS 15.0, *)
    func test_givenPokemonsWithAsyncRequestWithTask_whenResponseSuccessfull_thenShouldValidResponse() async throws {
        let expectation = XCTestExpectation(description: #function)

        let task = Task {
            let result = try await pokemonsService?.getPokemonsWithAsync()
            let resultsObject = try XCTUnwrap(result?.model)
            let firstObject = try XCTUnwrap(resultsObject.results.first)

            XCTAssertEqual(firstObject.name, "bulbasaur")

            expectation.fulfill()
        }

        await fulfillment(of: [expectation])
        task.cancel()
    }

    func test_givenPokemonsWithDataTaskRequest_whenResponseSuccessfull_thenShouldValidResponse() async {
        let expectation = XCTestExpectation(description: #function)
        var firstObject: Pokemon?

        pokemonsService?.getPokemonsWithDataTask { [weak self] (result: NetworkResult<PokemonsResponse>) in
            switch result {
            case .success(let response):
                firstObject = try? XCTUnwrap(response.results.first)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }

        await fulfillment(of: [expectation])
        XCTAssertEqual(firstObject?.name, "bulbasaur")
    }
}

final class MockNetworkManager: NetworkProvider {
    private let mockResponse = "{\"results\":[{\"name\":\"bulbasaur\",\"url\":\"https://pokeapi.co/api/v2/pokemon/1/\"}]}"

    func requestAsync<T: Decodable>(_ service: APIs) async throws -> NetworkResult<T> {
        guard let data = mockResponse.data(using: .utf8),
              let response = try? JSONDecoder().decode(PokemonsResponse.self, from: data) else {
            throw CustomError.decodeError
        }

        guard let response = response as? T else {
            throw CustomError.invalidData
        }

        return .success(response)
    }

    func request<T: Decodable>(_ service: APIs, completion: @escaping (NetworkResult<T>) -> Void) {
        guard let data = mockResponse.data(using: .utf8),
              let response = try? JSONDecoder().decode(PokemonsResponse.self, from: data) else {
            completion(.failure(CustomError.decodeError))
            return
        }

        guard let response = response as? T else {
            completion(.failure(CustomError.invalidData))
            return
        }
        completion(.success(response))
    }
}
