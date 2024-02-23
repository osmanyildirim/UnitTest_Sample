//
//  Requestable.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

protocol Requestable {
    /// JSONDecoder of decoding response's Data
    var decoder: JSONDecoder { get }

    /// HTTP method of request
    var httpMethod: String { get }

    /// The maximum amount of time that a resource request should be allowed to take
    var timeOut: TimeInterval { get }

    /// URL of request
    var url: URL? { get }

    /// query string parameters of URL
    var queryString: [String: String] { get }
}
