//
//  PhotoGridCellView.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import SwiftUI
import Combine

struct PhotoGridCellView: View {
    let photo: Photo
    let loadImage: () async -> Image?
    
    @State private var isLoading: Bool = false
    @State private var backgroundImage: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.secondary.opacity(0.25))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Group {
                            if let img = backgroundImage {
                                img
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .clipped()
            }
            Text(String(describing: photo.author))
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial, in: Rectangle())
        }
        .task(id: photo.id) {
            if backgroundImage == nil && !isLoading {
                isLoading = true
                backgroundImage = await loadImage()
                isLoading = false
            }
        }
        .cornerRadius(4.0)
        .shadow(radius: 4, x: 2, y: 2)
    }
}

#Preview {
    PhotoGridCellView(
        photo: .init(id: "1", author: "Test user", width: 400, height: 400, downloadUrl: "https://downloadUrl")) {
            return Image(systemName: "pencil")
        }
}
