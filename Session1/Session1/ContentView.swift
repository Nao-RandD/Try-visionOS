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
            Text("Hello, world!")
            Model3DView()
            SphereView()
        }
        .padding()
        .background(.black)
        .cornerRadius(30)
        .shadow(color: .green, radius: 0.8)
        // Windowを回転させる
//        .rotation3DEffect(Angle(degrees: 30), axis: (0, 1.0, 0))
        .navigationTitle("Content")
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
