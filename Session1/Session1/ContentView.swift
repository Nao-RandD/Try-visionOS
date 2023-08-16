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
        .padding()
        .background(.black)
        .cornerRadius(30)
        .shadow(color: .green, radius: 0.8)
        .rotation3DEffect(Angle(degrees: 30), axis: (0, 1.0, 0))
        .navigationTitle("Content")
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
