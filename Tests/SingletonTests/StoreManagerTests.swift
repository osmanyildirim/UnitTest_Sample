//
//  StoreManagerTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 22.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class StoreManagerTests: XCTestCase {
override func setUpWithError() throws {
    try super.setUpWithError()

    StoreManager.shared = MockStoreManager()
    StoreManager.shared.storedValue = 4
}

func test_givenMockStoreManager_whenSetStoredValue_thenShouldEqualToSettedValue() {
    XCTAssertEqual(StoreManager.shared.storedValue, 4)

    addTeardownBlock {
        StoreManager.shared.printStoredValue()
    }
}
}

final class MockStoreManager: StoreManager {
    static let sharedMock = MockStoreManager()

    override func printStoredValue() {
        debugPrint("Test is running. Stored value is: \(storedValue)")
    }
}
