//
//  PhotoCarouselView.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/9/26.
//

import SwiftUI

struct PhotoCarouselView: View {
    @StateObject var viewModel: PhotoCarouselViewModel = PhotoCarouselViewModel(
        photoService: PhotoService(),
        imageLoader: ImageLoader()
    )
    @State var currentIndex: Photo? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(viewModel.images) { photo in
                    PhotoCarouselCellView(photo: photo, loadImage: {
                        if let image = await viewModel.fetchImage(photo: photo) {
                            return Image(uiImage: image)
                        } else {
                            return nil
                        }
                    })
                }
            }
            .frame(height: 350)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Spacer()
        }
        .task {
            await viewModel.loadImages()
        }
    }
}

struct PhotoCarouselCellView: View {
    let photo: Photo
    let loadImage: () async -> Image?
    @State var image: Image? = nil
    
    @State var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary.opacity(0.25))
                .aspectRatio(1.0, contentMode: .fit)
            if isLoading {
                ProgressView()
            } else if let img = image {
                img
                    .resizable()
                    .scaledToFit()
            } else {
                Button("Retry") {
                    Task {
                        isLoading = true
                        image = await loadImage()
                        isLoading = false
                    }
                }
            }
        }
        .task {
            isLoading = true
            image = await loadImage()
            isLoading = false
        }
        .clipped()
        .background(in: .rect)
        .border(.black, width: 1.0)
        .cornerRadius(8.0)
    }
}

#Preview {
    PhotoCarouselCellView(
        photo: .init(id: "123", author: "KK", width: 200, height: 200, downloadUrl: ""),
        loadImage: { return nil }
    )
}

#Preview {
    PhotoCarouselView()
}
