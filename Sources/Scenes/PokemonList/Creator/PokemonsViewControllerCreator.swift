//
//  PokemonsViewControllerCreator.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import UIKit

final class PokemonsViewControllerCreator: BaseViewControllerCreator {
    typealias ViewModel = PokemonsViewModel

    static func create(viewModel: ViewModel? = nil) -> UIViewController {
        let viewController = PokemonsViewController()

        guard let viewModel else {
            viewController.viewModel = PokemonsViewModelCreator.create(viewController)
            return viewController
        }

        viewController.viewModel = viewModel
        return viewController
    }
}
