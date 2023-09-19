//
//  ObjectListView.swift
//  ObjectMakerVision
//
//  Created by Nao RandD on 2023/09/19.
//

import RealityKit
import SwiftUI

struct ObjectListView: View {

    @StateObject var viewModel = ObjectListViewModel()
    private let gridItems: [GridItem] = [.init(.adaptive(minimum: 240), spacing: 16)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.items) { item in
                    ObjectListItemView(item: item)
                        .onDrag {
                            guard let usdzURL = item.usdzURL else { return NSItemProvider() }
                            return NSItemProvider(object: USDZItemProvider(usdzURL: usdzURL))
                        }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 30)

        }
        .navigationTitle("XCA AR Inventory")
        .onAppear { viewModel.listenItems() }
    }
}

struct ObjectListItemView: View {

    let item: ObjectItem

    @EnvironmentObject var navVM: NavigationViewModel
    @Environment(\.openWindow) var openWindow

    var body: some View {
        Button {
            navVM.selectedItem = item
            openWindow(id: "item")
        } label: {
            VStack {
                ZStack {
                    if let usdzURL = item.usdzURL {
                        Model3D(url: usdzURL) { phase in
                            switch phase {

                            case .success(let model):
                                model.resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Text("Failed to download 3d model")
                            default: ProgressView()
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color.gray.opacity(0.3))
                        Text("Not available")
                    }
                }
                .frame(width: 160, height: 160)
                .padding(.bottom, 32)


                Text(item.name)
            }
            .frame(width: 240, height: 240)
            .padding(32)
        }
        .buttonStyle(.borderless)
        .buttonBorderShape(.roundedRectangle(radius: 20))

    }
}

#Preview {
    @StateObject var navigationViewModel = NavigationViewModel()

    return NavigationStack {
        ObjectListView()
            .environmentObject(navigationViewModel)
    }
}
