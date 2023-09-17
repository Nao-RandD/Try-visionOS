//
//  ObjectFormView.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import QuickLookThumbnailing

class ObjectFormViewModel: ObservableObject {

    let db = Firestore.firestore()
    let formType: FormType

    let id: String
    @Published var name = ""
    @Published var usdzURL: URL?
    @Published var thumbnailURL: URL?

    @Published var loadingState: LoadingType = .none
    @Published var error: String?

    @Published var uploadProgress: UploadProgress?
    @Published var showUSDZSource = false
    @Published var selectedUSDZSource: USDZSourceType?

    let byteCountFormatter: ByteCountFormatter = {
        let f = ByteCountFormatter()
        f.countStyle = .file
        return f
    }()

    var navigationTitle: String {
        switch formType {
        case .add:
            return "オブジェクトの追加"
        case .edit(let item):
            return "「\(item.name)」の編集"
        }
    }

    init(formType: FormType = .add) {
        self.formType = formType
        switch formType {
        case .add:
            id = UUID().uuidString
        case .edit(let item):
            id = item.id
            name = item.name
            if let usdzURL = item.usdzURL {
                self.usdzURL = usdzURL
            }
            if let thumbnailURL = item.thumbnailURL {
                self.thumbnailURL = thumbnailURL
            }
        }
    }

    func save() throws {
        loadingState = .savingItem

        defer { loadingState = .none }

        var item: ObjectItem
        switch formType {
        case .add:
            item = .init(id: id, name: name)
        case .edit(let beforeItem):
            item = beforeItem
            item.name = name
        }
        item.usdzLink = usdzURL?.absoluteString
        item.thumbnailLink = thumbnailURL?.absoluteString

        do {
            try db.document("items/\(item.id)").setData(from: item)
        } catch {
            self.error = error.localizedDescription
            throw error
        }
    }

    @MainActor
    func uploadUSDZ(fileURL: URL, isSecurityScopoedResource: Bool = false) async {
        if isSecurityScopoedResource, !fileURL.startAccessingSecurityScopedResource() {
            return
        }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        uploadProgress = .init(fractionCompleted: 0, totalUnitCount: 0, completedUnitCount: 0)
        loadingState = .uploading(.usdz)

        defer { loadingState = .none }
        do {
            let storageRef = Storage.storage().reference()
            let usdzRef = storageRef.child("\(id).usdz")

            _ = try await usdzRef.putDataAsync(data, metadata: .init(dictionary: ["contentType": "model/vnd.usd+zip"])) { [weak self] progress in
                guard let self, let progress else { return }
                self.uploadProgress = .init(fractionCompleted: progress.fractionCompleted,
                                            totalUnitCount: progress.totalUnitCount,
                                            completedUnitCount: progress.completedUnitCount)
            }
            let downloadURL = try await usdzRef.downloadURL()
            self.usdzURL = downloadURL

            let cacheDirURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileCacheURL = cacheDirURL.appending(path: "temp_\(id).usdz")
            try? data.write(to: fileCacheURL)

            let thumbnailRequest = QLThumbnailGenerator.Request(fileAt: fileCacheURL,
                                                                size: .init(width: 300, height: 300),
                                                                scale: UIScreen.main.scale, representationTypes: .all)

            if let thumbnal = try? await QLThumbnailGenerator.shared.generateBestRepresentation(for: thumbnailRequest),
               let jpgData = thumbnal.uiImage.jpegData(compressionQuality: 0.5) {
                loadingState = .uploading(.thumbnail)
                let thumbnailRef = storageRef.child("\(id).jpg")
                _ = try? await thumbnailRef.putDataAsync(jpgData, metadata: .init(dictionary: ["contentType": "image/jpeg"])) { [weak self] progress in
                    guard let self, let progress else { return }
                    self.uploadProgress = .init(fractionCompleted: progress.fractionCompleted,
                                                totalUnitCount: progress.totalUnitCount,
                                                completedUnitCount: progress.completedUnitCount)
                }

                if let thumbnailURL = try? await thumbnailRef.downloadURL() {
                    self.thumbnailURL = thumbnailURL
                }
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}

