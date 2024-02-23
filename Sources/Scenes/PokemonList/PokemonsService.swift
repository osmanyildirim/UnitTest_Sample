//
//  PokemonsService.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 14.02.2024.
//

import Foundation

protocol PokemonsRetrievalService {
    @available(iOS 15.0, *)
    func getPokemonsWithAsync() async throws -> NetworkResult<PokemonsResponse>

    func getPokemonsWithDataTask(completion: @escaping ((NetworkResult<PokemonsResponse>) -> Void))
}

final class PokemonsService: PokemonsRetrievalService {
    let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    @available(iOS 15.0, *)
    func getPokemonsWithAsync() async throws -> NetworkResult<PokemonsResponse> {
        try await networkProvider.requestAsync(.pokemons)
    }

    func getPokemonsWithDataTask(completion: @escaping ((NetworkResult<PokemonsResponse>) -> Void)) {
        networkProvider.request(.pokemons) { [weak self] (result: NetworkResult<PokemonsResponse>) in
            completion(result)
        }
    }
}
