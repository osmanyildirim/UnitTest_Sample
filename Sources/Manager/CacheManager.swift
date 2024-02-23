//
//  CacheManager.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 19.02.2024.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()

    var cachedValue: Int = 1

    func printCachedValue() {
        debugPrint("App is running. Cached value is: \(cachedValue)")
    }
}
