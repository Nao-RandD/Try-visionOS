//
//  ObjectMakerVisionApp.swift
//  ObjectMakerVision
//
//  Created by Nao RandD on 2023/09/17.
//

import SwiftUI

@main
struct ObjectMakerVisionApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var navigationViewModel = NavigationViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ObjectListView()
                    .environmentObject(navigationViewModel)
            }
        }

        WindowGroup(id: "item") {
            ObjectItemView().environmentObject(navigationViewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
    }
}
