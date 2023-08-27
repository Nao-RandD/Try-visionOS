//
//  Model3DView.swift
//  Session1
//
//  Created by Nao RandD on 2023/08/27.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Model3DView: View {
    var body: some View {
        Model3D(named: "Scene", bundle: realityKitContentBundle)
            .padding(.bottom, 50)
    }
}

#Preview {
    Model3DView()
}
