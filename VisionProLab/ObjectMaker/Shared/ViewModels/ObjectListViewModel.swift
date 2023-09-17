//
//  ObjectListViewModel.swift
//  ObjectMakerVision
//
//  Created by Nao RandD on 2023/09/17.
//

import Foundation
import FirebaseFirestore
import SwiftUI

final class ObjectListViewModel: ObservableObject {
    @Published var items = [ObjectItem]()

    @MainActor
    func listenItems() {
        Firestore.firestore().collection("items")
            .order(by: "name")
            .limit(toLast: 100)
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "none")")
                    return
                }
                let docs = snapshot.documents
                let items = docs.compactMap {
                    try? $0.data(as: ObjectItem.self)
                }

                withAnimation {
                    self.items = items
                }
            }
    }
}
