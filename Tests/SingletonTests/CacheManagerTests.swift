//
//  CacheManagerTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 22.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class CacheManagerTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()

        MockCacheManager.sharedMock.cachedValue = 3
    }

    func test_givenMockCacheManager_whenSetCachedValue_thenShouldEqualToSettedValue() {
        XCTAssertEqual(MockCacheManager.sharedMock.cachedValue, 3)

        addTeardownBlock {
            MockCacheManager.sharedMock.printCachedValue()
        }
    }
}

final class MockCacheManager: CacheManager {
    static let sharedMock = MockCacheManager()

    override func printCachedValue() {
        debugPrint("Test is running. Cached value is: \(cachedValue)")
    }
}
