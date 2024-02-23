//
//  ResourceManager.swift
//  UnitTestExtension
//
//  Created by osmanyildirim on 8.01.2024.
//

import Foundation
@testable import UnitTest_Sample

final class ResourceManager {
    enum FileType {
        case json

        var value: String {
            String(describing: self)
        }
    }

    static func jsonData(fileName: String, fileType: FileType) -> Data? {
        guard let url = Bundle(for: NetworkManagerTests.self).url(forResource: fileName, withExtension: fileType.value) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
