//
//  StoreManager.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 22.02.2024.
//

import Foundation

class StoreManager: NSObject {
    #if TEST
        static var shared: StoreManager!
    #else
        // Only accessible using singleton
        static let shared = StoreManager()
    #endif

    var storedValue = 2

    func printStoredValue() {
        debugPrint("App is running. Cached value is: \(storedValue)")
    }
}
