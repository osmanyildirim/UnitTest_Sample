//
//  PokemonsViewModel.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import UIKit

protocol PokemonsViewModelDelegate: BaseViewModel {
    func fetchPokemonsDidSuccess()
    func fetchPokemonsDidFail(_ error: Error)
}

final class PokemonsViewModel {
    private var pokemonsService: PokemonsRetrievalService?
    @Published private(set) var pokemons: [Pokemon]?
    private(set) weak var delegate: PokemonsViewModelDelegate?

    init(pokemonsService: PokemonsRetrievalService, delegate: BaseViewModel?) {
        self.pokemonsService = pokemonsService
        self.delegate = delegate as? PokemonsViewModelDelegate
    }

    func getPokemons() {
        if #available(iOS 15.0, *) {
            Task {
                let result = try await pokemonsService?.getPokemonsWithAsync()
                switch result {
                case .success(let response):
                    self.pokemons = response.results
                    self.delegate?.fetchPokemonsDidSuccess()
                case .failure(let error):
                    self.delegate?.fetchPokemonsDidFail(error)
                case .none:
                    return
                }
            }
        } else {
            pokemonsService?.getPokemonsWithDataTask { [weak self] result in
                switch result {
                case .success(let response):
                    self?.pokemons = response.results
                    self?.delegate?.fetchPokemonsDidSuccess()
                case .failure(let error):
                    self?.delegate?.fetchPokemonsDidFail(error)
                }
            }
        }
    }

    func getPokemon(index: Int) -> Pokemon? {
        pokemons?[index]
    }

    @available(iOS 15.0, *)
    @MainActor
    func getPokemonsWithMainActor() async throws {
        let result = try await pokemonsService?.getPokemonsWithAsync()
        switch result {
        case .success(let response):
            pokemons = response.results
        case .failure, .none:
            pokemons?.removeAll()
        }
    }

    func setPokemons(pokemons: [Pokemon]?) {
        self.pokemons = pokemons
    }
}
