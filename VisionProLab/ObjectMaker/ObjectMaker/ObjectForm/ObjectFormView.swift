//
//  ObjectFormView.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import SwiftUI
import SafariServices
import UniformTypeIdentifiers
//import USDZScanner

struct ObjectFormView: View {

    @StateObject var viewModel = ObjectFormViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            List {
                Section {
                    TextField("Name", text: $viewModel.name)
                }
                .disabled(viewModel.loadingState != .none)
                arSection
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .disabled(viewModel.loadingState != .none)
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    do {
                        try viewModel.save()
                        dismiss()
                    } catch {}
                }
                .disabled(viewModel.loadingState != .none || viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .confirmationDialog("USDZを追加", isPresented: $viewModel.showUSDZSource, titleVisibility: .visible) {
            Button("ファイル選択") {
                viewModel.selectedUSDZSource = .fileImporter
            }

            Button("Object Capture") {
                viewModel.selectedUSDZSource = .objectCapture
            }
        }
        .sheet(isPresented: .init(get: {
            viewModel.selectedUSDZSource == .objectCapture
        }, set: { _ in
            viewModel.selectedUSDZSource = nil
        }), content: {
            // TODO: USDZScanner
        })
        .fileImporter(isPresented: .init(get: {
            viewModel.selectedUSDZSource == .fileImporter
        }, set: { _ in
            viewModel.selectedUSDZSource = nil
        }), allowedContentTypes: [UTType.usdz], onCompletion: { result in
            switch result {
            case .success(let url):
                Task {
                    await viewModel.uploadUSDZ(fileURL: url, isSecurityScopoedResource: true)
                }
            case .failure(let failure):
                viewModel.error = failure.localizedDescription
            }
        })
        .alert(isPresented: .init(get: { viewModel.error != nil }, set: { _ in
            viewModel.error = nil
        }), error: "問題が発生しました", actions: { _ in }, message: { _ in
            Text(viewModel.error ?? "")
        })
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    var arSection: some View {
        Section("AR Model") {
            if let thumbnailURL = viewModel.thumbnailURL {
                AsyncImage(url: thumbnailURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    case .failure:
                        Text("サムネイル画像の取得に失敗しました")
                    default: ProgressView()
                    }
                }
                .onTapGesture {
                    guard let usdzURL = viewModel.usdzURL else { return }
                    viewAR(url: usdzURL)
                }
            }

            if let usdzURL = viewModel.usdzURL {
                Button {
                    viewAR(url: usdzURL)
                } label: {
                    HStack {
                        Image(systemName: "arkit")
                            .imageScale(.large)
                        Text("View")
                    }
                }
            } else {
                Button {
                    viewModel.showUSDZSource = true
                } label: {
                    HStack {
                        Image(systemName: "arkit")
                            .imageScale(.large)
                        Text("USDZの追加")
                    }
                }
            }

            if let progress = viewModel.uploadProgress,
               case let .uploading(type) = viewModel.loadingState,
               progress.totalUnitCount > 0 {
                VStack {
                    ProgressView(value: progress.fractionCompleted) {
                        Text("アップロード中 \(type == .usdz ? "USDZ": "Thumbnail") file \(Int(progress.fractionCompleted * 100))%")
                    }
                    Text("\(viewModel.byteCountFormatter.string(fromByteCount: progress.completedUnitCount)) / \(viewModel.byteCountFormatter.string(fromByteCount: progress.totalUnitCount))")
                }
            }
        }
        .disabled(viewModel.loadingState != .none)
    }

    func viewAR(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        let vc = UIApplication.shared.firstKeyWindow?.rootViewController?.presentedViewController ?? UIApplication.shared.firstKeyWindow?.rootViewController
        vc?.present(safariVC, animated: true)
    }
}

extension UIApplication {

    var firstKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}

#Preview {
    NavigationStack {
        ObjectFormView()
    }
}
