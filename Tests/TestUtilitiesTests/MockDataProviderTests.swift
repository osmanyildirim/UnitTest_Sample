//
//  MockDataProviderTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 13.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class MockDataProviderTests: XCTestCase {
    private var mockSuccessResponse: PokemonsResponse?
    private var mockFailResponse: PokemonsResponse?

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockSuccessResponse = try? MockDataProvider<PokemonsResponse>.test(behavior: .success, mockFile: "PokemonsResponseMock")
        mockFailResponse = try? MockDataProvider<PokemonsResponse>.test(behavior: .fail, mockFile: "PokemonsResponseMock")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        mockSuccessResponse = nil
        mockFailResponse = nil
    }

    func test_givenMockDataProvider_whenSuccessBehavior_thenShouldNotNil() {
        XCTAssertNotNil(mockSuccessResponse)
    }

    func test_givenMockDataProvider_whenFailBehavior_thenShouldNil() {
        XCTAssertNil(mockFailResponse)
    }

    func test_givenMockDataProvider_whenFailBehavior_thenShouldThrow() throws {
        XCTAssertThrowsError(try MockDataProvider<PokemonsResponse>.test(behavior: .fail, mockFile: "PokemonsResponseMock"))
    }

    func test_givenMockData_whenSuccessObject_thenShouldValidValues() throws {
        let resultsObject = try XCTUnwrap(mockSuccessResponse?.results)
        XCTAssert(!resultsObject.isEmpty)

        let firstObject = try XCTUnwrap(resultsObject.first)
        XCTAssertEqual(firstObject.name, "bulbasaur")
    }
}
