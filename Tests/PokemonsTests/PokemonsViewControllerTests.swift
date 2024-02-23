//
//  PokemonsViewControllerTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 14.02.2024.
//

import XCTest
import Combine
@testable import UnitTest_Sample

final class PokemonsViewControllerTests: XCTestCase {
    private var sut: PokemonsViewController?
    private var viewModel: PokemonsViewModel?
    private var delegate: MockPokemonsViewModelDelegate?

    override func setUpWithError() throws {
        try super.setUpWithError()

        delegate = MockPokemonsViewModelDelegate()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
        viewModel = nil
        delegate = nil
    }

    func test_givenSuccessMockService_whenCallOnViewModel_thenShouldCalledDelegateSuccessMethod() {
        let expectation = expectation(description: #function)

        delegate?.expectation = expectation
        viewModel = PokemonsViewModel(pokemonsService: MockPokemonsServiceOnViewModel(), delegate: delegate)
        sut = PokemonsViewControllerCreator.create(viewModel: viewModel) as? PokemonsViewController
        _ = sut?.view

        wait(for: [expectation])
        XCTAssertEqual(delegate?.didSuccess, true)
    }

    func test_givenFailMockService_whenCallOnViewModel_thenShouldCalledDelegateFailMethod() {
        let expectation = expectation(description: #function)

        delegate?.expectation = expectation
        viewModel = PokemonsViewModel(pokemonsService: MockFailPokemonsServiceOnViewModel(), delegate: delegate)
        sut = PokemonsViewControllerCreator.create(viewModel: viewModel) as? PokemonsViewController
        _ = sut?.view

        wait(for: [expectation])
        XCTAssertEqual(delegate?.didSuccess, false)
    }
}

final class MockPokemonsViewModelDelegate: PokemonsViewModelDelegate {
    private(set) var didSuccess = false
    var expectation: XCTestExpectation?

    func fetchPokemonsDidSuccess() {
        didSuccess = true
        expectation?.fulfill()
    }

    func fetchPokemonsDidFail(_ error: Error) {
        didSuccess = false
        expectation?.fulfill()
    }
}
