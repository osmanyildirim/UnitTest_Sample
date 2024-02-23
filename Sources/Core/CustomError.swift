//
//  Error.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

enum CustomError: Error {
    case badRequest
    case invalidData
    case invalidURL
    case decodeError
    case requestFailed

    var description: String {
        switch self {
        case .badRequest:
            return "badRequest"
        default:
            return "genericError"
        }
    }
}
