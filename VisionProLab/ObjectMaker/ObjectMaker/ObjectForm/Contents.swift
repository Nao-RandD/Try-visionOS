//
//  Contents.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import Foundation

enum FormType: Identifiable {

    case add
    case edit(ObjectItem)

    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let item):
            return "edit-\(item.id)"
        }
    }
}

enum LoadingType: Equatable {
    case none
    case savingItem
    case uploading(UploadType)
}

enum USDZSourceType {
    case fileImporter, objectCapture
}

enum UploadType: Equatable {
    case usdz, thumbnail
}

struct UploadProgress {
    var fractionCompleted: Double
    var totalUnitCount: Int64
    var completedUnitCount: Int64
}
