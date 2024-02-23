//
//  ImageFetcherTests.swift
//  UnitTest_SampleTests
//
//  Created by osmanyildirim on 19.02.2024.
//

import XCTest
@testable import UnitTest_Sample

final class ImageFetcherTests: XCTestCase {
    private var url: URL?
    private var viewController: PokemonsViewController?
    private var sut: ImageFetcher?

    override func setUpWithError() throws {
        try super.setUpWithError()

        url = URL(string: "https://source.unsplash.com/random/300x300")
        viewController = PokemonsViewControllerCreator.create() as? PokemonsViewController
        sut = ImageFetcher()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        url = nil
        viewController = nil
        sut = nil
    }

    func test_givenImageURL_whenImageDataSuccessfull_thenShouldImageNotNil() async throws {
        guard let url else {
            throw CustomError.invalidURL
        }

        let image = try await sut?.fetchImage(for: url)
        XCTAssertNotNil(image)
    }

    func test_givenInvalidImageURL_whenImageDataFail_thenShouldThrowsError() async throws {
        url = URL(string: "https://source.unsplash.com/")

        guard let url else {
            throw CustomError.invalidURL
        }

        let image = try? await sut?.fetchImage(for: url)
        XCTAssertNil(image)
    }

    func test_givenImageFetched_whenImageViewSetImageWithCallback_thenShouldImageNotNilOfImageView() throws {
        guard let url else {
            throw CustomError.invalidURL
        }

        let expectation = XCTestExpectation(description: #function)

        viewController?.setImage(url: url, completion: {
            expectation.fulfill()
        })
        wait(for: [expectation])
        XCTAssertNotNil(viewController?.imageView.image)
    }

    @MainActor
    func test_givenImageFetched_whenImageViewSetImageWithCallbackAndAwaitForFulFillment_thenShouldImageNotNilOfImageView() async throws {
        guard let url else {
            throw CustomError.invalidURL
        }

        let expectation = XCTestExpectation(description: #function)

        viewController?.setImage(url: url, completion: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation])
        XCTAssertNotNil(viewController?.imageView.image)
    }

    @MainActor
    func test_givenImageFetched_whenImageViewSetImageWithAwait_thenShouldImageNotNilOfImageView() async throws {
        guard let url else {
            throw CustomError.invalidURL
        }

        await viewController?.setImage(url: url)
        XCTAssertNotNil(viewController?.imageView.image)
    }
}
