//
//  PokemonsViewModelCreator.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import Foundation

final class PokemonsViewModelCreator: BaseViewModelCreator {
    typealias ViewModel = PokemonsViewModel

    static func create(_ viewController: BaseViewModel?) -> PokemonsViewModel {
        PokemonsViewModel(pokemonsService: PokemonsService(networkProvider: NetworkManager()), delegate: viewController)
    }
}
