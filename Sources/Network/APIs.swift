//
//  APIs.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

enum APIs: Requestable {
    case pokemons
}

extension APIs {
    /// all request will use default decoder
    var decoder: JSONDecoder {
        Decoders.default
    }

    /// requests will use GET and POST methods
    var httpMethod: String {
        return "POST"
    }

    /// All request 's timeout interval is 30 seconds
    var timeOut: TimeInterval {
        return 30
    }

    /// URL of requests
    var url: URL? {
        return URLs.pokemon.create(queryString)
    }

    var queryString: [String: String] {
        return ["offset": "0"]
    }
}
