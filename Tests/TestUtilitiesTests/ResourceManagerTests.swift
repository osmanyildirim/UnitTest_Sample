//
//  ResourceManagerTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 13.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class ResourceManagerTests: XCTestCase {
    private var mockResponseData: Data?
    private var invalidMockResponseData: Data?

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockResponseData = ResourceManager.jsonData(fileName: "PokemonsResponseMock", fileType: .json)
        invalidMockResponseData = ResourceManager.jsonData(fileName: "PokemonsResponseMock_Invalid", fileType: .json)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        mockResponseData = nil
        invalidMockResponseData = nil
    }

    func test_givenLocalFile_whenMockJson_thenShouldNotNil() throws {
        XCTAssertNotNil(mockResponseData)
        XCTAssert(!(mockResponseData ?? Data()).isEmpty)
    }

    func test_givenInvalidLocalFile_whenMockJson_thenShouldNil() throws {
        XCTExpectFailure(#function)

        XCTAssertNotNil(invalidMockResponseData)
    }
}
