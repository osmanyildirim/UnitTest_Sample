//
//  URLs.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

enum URLs {
    case pokemon
}

extension URLs {
    static let Scheme = "https"
    static let Host = "pokeapi.co"
    static let Api = "/api/v2"

    func create(_ queryString: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = URLs.Scheme
        components.host = URLs.Host
        components.path = #"\#(URLs.Api)/\#(method)"#

        guard let dict = queryString.first else { return components.url }
        components.queryItems = [URLQueryItem(name: dict.key, value: dict.value)]
        return components.url
    }

    private var method: String {
        String(describing: self)
    }
}
