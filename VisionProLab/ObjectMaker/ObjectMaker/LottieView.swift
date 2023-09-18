//
//  LottieView.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/18.
//

import SwiftUI
import Lottie

enum LottieFileType: String {
    case placeholder = "metaverse_with_grass"
    case loading = "loading"
}

struct LottieView: UIViewRepresentable {
    let resourceType: LottieFileType

    func updateUIView(_ uiView: UIView, context: Context) {
    }

    func makeUIView(context: Context) -> UIView {
        let view = LottieAnimationView(name:  resourceType.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false

        let parentView = UIView()
        parentView.addSubview(view)
        parentView.addConstraints([
            view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: parentView.heightAnchor)
        ])

        view.play()
        view.loopMode = .loop

        return parentView
    }
}

