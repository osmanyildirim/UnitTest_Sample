//
//  PokemonsViewController.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import UIKit

final class PokemonsViewController: UIViewController {
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var viewModel: PokemonsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()

        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.dataSource = self

        viewModel?.getPokemons()
    }

    func setupViews() {
        view.addSubview(tableView)
        tableView.keyboardDismissMode = .interactive
    }

    func setupLayout() {
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

extension PokemonsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel?.pokemons?.count ?? 0 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell, let pokemon = viewModel?.getPokemon(index: indexPath.row) {
            cell.configure(pokemon)
            return cell
        }
        return .init()
    }
}

extension PokemonsViewController: PokemonsViewModelDelegate {
    func fetchPokemonsDidSuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func fetchPokemonsDidFail(_ error: Error) {
        fatalError("data couldn't retrieve")
    }
}

extension PokemonsViewController {
    func setImage(url: URL) async {
        let imageFetcher = ImageFetcher()
        let image = try? await imageFetcher.fetchImage(for: url)
        imageView.image = image
    }

    func setImage(url: URL, completion: (() -> Void)?) {
        let imageFetcher = ImageFetcher()

        Task {
            let image = try? await imageFetcher.fetchImage(for: url)

            await MainActor.run {
                imageView.image = image
                completion?()
            }
        }
    }
}
