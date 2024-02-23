//
//  ImageFetcher.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 19.02.2024.
//

import UIKit

struct ImageFetcher {
    func fetchImage(for url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)

        guard let image = UIImage(data: data) else {
            throw CustomError.invalidData
        }
        return image
    }
}
