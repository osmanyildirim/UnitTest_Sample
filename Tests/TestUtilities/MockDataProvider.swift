//
//  MockDataProvider.swift
//  UnitTestExtension
//
//  Created by osmanyildirim on 8.01.2024.
//

import Foundation
@testable import UnitTest_Sample

final class MockDataProvider<T: Decodable> {
    static func test(behavior: TestBehavior, mockFile: String) throws -> T? {
        guard behavior != .fail else {
            throw TestError.mockError
        }

        guard let jsonData = ResourceManager.jsonData(fileName: mockFile, fileType: .json) else {
            throw TestError.mockError
        }

        return try? jsonData.decode() as T
    }
}

extension MockDataProvider {
    enum TestBehavior {
        case success
        case fail
    }
}
