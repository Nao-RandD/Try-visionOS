//
//  ObjectListView.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import SwiftUI

struct ObjectListView: View {

    @StateObject var viewModel = ObjectListViewModel()
    @State var formType: FormType?

    var body: some View {
        LottieView(resourceType: .placeholder)
            .frame(width: 300, height: 200)
        List {
            ForEach(viewModel.items) { item in
                ObjectListItemView(item: item)
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        formType = .edit(item)
                    }
            }
        }
        .navigationTitle("Object List")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("追加") {
                    formType = .add
                }
            }
        }
        .sheet(item: $formType) { type in
            NavigationStack {
                ObjectFormView(viewModel: .init(formType: type))
            }
            .presentationDetents([.fraction(0.85)])
            .interactiveDismissDisabled()
        }
        .onAppear {
            viewModel.listenItems()
        }
    }

    struct ObjectListItemView: View {
        
        let item: ObjectItem

        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.gray.opacity(0.3))

                    if let thumbnailURL = item.thumbnailURL {
                        AsyncImage(url: thumbnailURL) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            default:
                                ProgressView()
                            }
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .frame(width: 150, height: 150)

                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ObjectListView()

    }
}
