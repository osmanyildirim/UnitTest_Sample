//
//  AppDelegate.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PokemonsViewControllerCreator.create()
        window?.makeKeyAndVisible()

        CacheManager.shared.cachedValue = 10

        #if TEST
        #else
            StoreManager.shared.storedValue = 11
        #endif

        return true
    }
}
