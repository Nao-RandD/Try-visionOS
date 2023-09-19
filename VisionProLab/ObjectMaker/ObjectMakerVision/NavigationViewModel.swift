//
//  NavigationViewModel.swift
//  ObjectMakerVision
//
//  Created by Nao RandD on 2023/09/19.
//

import SwiftUI

class NavigationViewModel: ObservableObject {

    @Published var selectedItem: ObjectItem?

    init(selectedItem: ObjectItem? = nil) {
        self.selectedItem = selectedItem
    }
}
