//
//  PokemonCell.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import UIKit

final class PokemonCell: UITableViewCell, BaseTableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.addSubview(nameLabel)
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    override func prepareForReuse() {
        nameLabel.text?.removeAll()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(containerView)
    }

    func setupLayout() {
    }
}

extension PokemonCell {
    func configure(_ pokemon: Pokemon) {
        nameLabel.text = pokemon.name
    }
}
