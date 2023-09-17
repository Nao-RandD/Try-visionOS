//
//  AppDelegate.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        setupFirebaseLocalEmulator()

        return true
    }

    func setupFirebaseLocalEmulator() {
        var host = "127.0.0.1"
        #if !targetEnvironment(simulator)
        host = "10.18.104.50"
        #endif

        // MARK: Firestore
        let settings = Firestore.firestore().settings
        settings.host = "\(host):8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings

        Storage.storage().useEmulator(withHost: host, port: 9199)
    }
}

