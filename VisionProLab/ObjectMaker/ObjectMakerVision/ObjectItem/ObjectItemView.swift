//
//  ObjectItemView.swift
//  ObjectMakerVision
//
//  Created by Nao RandD on 2023/09/19.
//

import RealityKit
import SwiftUI

struct ObjectItemView: View {

    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = ObjectItemViewModel()

    // 3d rotation
    @State var angle: Angle = .degrees(0)
    @State var startAngle: Angle?

    @State var axis: (CGFloat, CGFloat, CGFloat) = (.zero, .zero, .zero)
    @State var startAxis: (CGFloat, CGFloat, CGFloat)?

    // ScaleEffect
    @State var scale: Double = 2
    @State var startScale: Double?

    var body: some View {
        ZStack(alignment: .bottom) {
            RealityView { _ in }
              update: { content in
                  if viewModel.entity == nil && !content.entities.isEmpty {
                      content.entities.removeAll()
                  }

                  if let entity = viewModel.entity {
                      if let currentEntity = content.entities.first, entity == currentEntity {
                          return
                      }
                      content.entities.removeAll()
                      content.add(entity)
                  }
              }
              .rotation3DEffect(angle, axis: axis)
              .scaleEffect(scale)
              .simultaneousGesture(DragGesture()
                .onChanged({ value in
                    if let startAngle, let startAxis {
                        let _angle = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2)) + startAngle.degrees
                        let axisX = ((-value.translation.height + startAxis.0) / CGFloat(_angle))
                        let axisY = ((value.translation.width + startAxis.1) / CGFloat(_angle))
                        angle = Angle(degrees: Double(_angle))
                        axis = (axisX, axisY, 0)
                    } else {
                        startAngle = angle
                        startAxis = axis
                    }
                }).onEnded({ _ in
                    startAngle = angle
                    startAxis = axis
                }))
              .simultaneousGesture(MagnifyGesture()
                .onChanged { value in
                    if let startScale {
                        scale = max(1, min(3, value.magnification * startScale))
                    } else {
                        startScale = scale
                    }
                }
                .onEnded { _ in
                    startScale = scale
                }
              )
              .zIndex(1)



            VStack {
                Text(viewModel.item?.name ?? "")
            }
            .padding(32)
            .background(.ultraThinMaterial).cornerRadius(16)
            .font(.extraLargeTitle)
            .zIndex(1)
        }
        .onAppear {
            guard let item = navigationViewModel.selectedItem else { return }
            viewModel.onItemDeleted = { dismiss() }
            viewModel.listenToItem(item)
        }
    }
}

#Preview {

    @StateObject var navigationViewModel = NavigationViewModel(selectedItem: .init(id: "25CEF568-5B5C-46CF-A19C-17459AF7DCE9", name: ""))

    return ObjectItemView()
        .environmentObject(navigationViewModel)
}
