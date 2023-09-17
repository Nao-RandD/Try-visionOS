//
//  ObjectListView.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import SwiftUI

struct ObjectListView: View {

    @StateObject var viewModel = ObjectListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                Text(item.name)
            }
        }
        .navigationTitle("Object List")
        .onAppear {
            viewModel.listenItems()
        }
    }
}

#Preview {
    NavigationStack {
        ObjectListView()

    }
}
