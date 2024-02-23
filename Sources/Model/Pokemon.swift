//
//  Pokemon.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

struct PokemonsResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name, url: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decodeIfPresent(String.self, forKey: .name)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
