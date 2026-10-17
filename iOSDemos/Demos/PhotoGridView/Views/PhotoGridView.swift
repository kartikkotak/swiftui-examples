//
//  PhotoGridView.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import SwiftUI
import Combine

struct PhotoGridView: View {
    @Environment(\.verticalSizeClass) var orientation
    @StateObject var viewModel: PhotoGridViewModel = PhotoGridViewModel(photoRepository: PhotoService(), imageLoader: ImageLoader())
    
    @State private var isPortrait: Bool = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
    
    let portraitColumnLayout = Array(repeating: GridItem(spacing: 8.0), count: 2)
    let landscapeColumnLayout = Array(repeating: GridItem(spacing: 8.0), count: 4)
    
    var body: some View {
        VStack {
            ScrollView {
                Group {
                    if isPortrait {
                        LazyVGrid(columns: portraitColumnLayout) {
                            gridContent()
                        }
                    } else {
                        LazyVGrid(columns: landscapeColumnLayout) {
                            gridContent()
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.refresh()
            }
            if viewModel.fetchMore {
                ProgressView()
            }
        }
        .background(.regularMaterial)
        .task(id: viewModel.fetchMore, {
            await viewModel.fetchMoreImages()
            viewModel.fetchMore = false
        })
        .task {
            await viewModel.loadInitialPhotos()
        }
        .navigationTitle("Lazy Photo Grid")
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            isPortrait = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        }
    }
    
    private func gridContent() -> some View {
        ForEach(viewModel.photos.enumerated(), id: \.offset) { index, photo in
            PhotoGridCellView(photo: photo) {
                if let uiImage = await viewModel.fetchPhotoImage(photo) {
                    return Image(uiImage: uiImage)
                }
                return nil
            }
            .onAppear {
                // If reached second last row, then fetch more
                if index >= viewModel.photos.count - 1, viewModel.fetchMore == false {
                    viewModel.fetchMore = true
                }
            }
        }
        .animation(.easeInOut(duration: 1.5), value: viewModel.photos)
    }
}

#Preview {
    PhotoGridView()
}
