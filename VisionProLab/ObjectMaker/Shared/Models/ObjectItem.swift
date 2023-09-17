//
//  ObjectItem.swift
//  ObjectMakerVision
//
//  Created by Nao RandD on 2023/09/17.
//

import Foundation
import FirebaseFirestoreSwift

struct ObjectItem: Identifiable, Codable, Equatable {

    var id = UUID().uuidString
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?

    var name: String

    var usdzLink: String?
    var usdzURL: URL? {
        guard let usdzLink else { return nil }
        return URL(string: usdzLink)
    }

    var thumbnailLink: String?
    var thumbnailURL: URL? {
        guard let thumbnailLink else { return nil }
        return URL(string: thumbnailLink)
    }
}
