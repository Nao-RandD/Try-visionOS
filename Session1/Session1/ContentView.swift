//
//  ContentView.swift
//  Session1
//
//  Created by Nao RandD on 2023/08/11.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
        }
        .navigationTitle("Content")
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
