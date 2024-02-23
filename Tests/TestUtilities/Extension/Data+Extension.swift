//
//  Data+Extension.swift
//  UnitTestExtension
//
//  Created by osmanyildirim on 8.01.2024.
//

import Foundation

extension Data {
    func decode<T: Decodable>(decoder: JSONDecoder = .init()) throws -> T {
        guard let response = try? decoder.decode(T.self, from: self) else {
            throw TestError.decodeError
        }
        return response
    }
}
