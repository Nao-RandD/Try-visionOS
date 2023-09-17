//
//  ObjectMakerApp.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import SwiftUI

@main
struct ObjectMakerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ObjectListView()
            }
        }
    }
}
