//
//  PokemonsViewModelTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 14.02.2024.
//

import XCTest
import Combine
@testable import UnitTest_Sample

final class PokemonsViewModelTests: XCTestCase {
    private var pokemonsService: MockPokemonsServiceOnViewModel?
    private var sut: PokemonsViewModel?
    private var cancellables: Set<AnyCancellable>?

    override func setUpWithError() throws {
        try super.setUpWithError()

        pokemonsService = MockPokemonsServiceOnViewModel()

        guard let pokemonsService else { return }
        sut = PokemonsViewModel(pokemonsService: pokemonsService, delegate: nil)
        cancellables = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        pokemonsService = nil
        sut = nil
        cancellables = nil
    }

    func test_givenPokemonsProperty_whenSetFromWithCombine_thenShouldValidResponse() async throws {
        guard let sut, var cancellables = self.cancellables else {
            throw CustomError.invalidData
        }

        sut.$pokemons
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.count, 1)
        }).store(in: &cancellables)

        let result = try await pokemonsService?.getPokemonsWithAsync()
        let mockPokemons = result?.model?.results
        sut.setPokemons(pokemons: mockPokemons)
    }

    @available(iOS 15.0, *)
    func test_givenCallWithMainActorOnViewModel_whenSetToPropery_thenShouldValidResponse() async throws {
        guard let sut else {
            throw CustomError.requestFailed
        }

        try await sut.getPokemonsWithMainActor()
        let pokemons = try XCTUnwrap(sut.pokemons)
        XCTAssertEqual(pokemons.count, 1)

        let firstObject = try XCTUnwrap(pokemons.first)
        XCTAssertEqual(firstObject.name, "pikachu")
    }
}

class MockPokemonsServiceOnViewModel: PokemonsRetrievalService {
    var mockResponse: String {
        "{\"results\":[{\"name\":\"pikachu\",\"url\":\"https://pokeapi.co/api/v2/pokemon/1/\"}]}"
    }

    func getPokemonsWithAsync() async -> NetworkResult<PokemonsResponse> {
        guard let data = mockResponse.data(using: .utf8),
              let response = try? JSONDecoder().decode(PokemonsResponse.self, from: data) else {
            return .failure(CustomError.decodeError)
        }

        return .success(response)
    }

    func getPokemonsWithDataTask(completion: @escaping ((NetworkResult<PokemonsResponse>) -> Void)) {
        guard let data = mockResponse.data(using: .utf8),
              let response = try? JSONDecoder().decode(PokemonsResponse.self, from: data) else {
            completion(.failure(CustomError.decodeError))
            return
        }
        completion(.success(response))
    }
}

final class MockFailPokemonsServiceOnViewModel: MockPokemonsServiceOnViewModel {
    override var mockResponse: String {
        "data couldn't retrieve"
    }
}
