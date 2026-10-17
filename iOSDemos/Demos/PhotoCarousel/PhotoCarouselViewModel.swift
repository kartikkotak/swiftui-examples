//
//  PhotoCarousel.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/9/26.
//

import Combine
import SwiftUI

@MainActor
final class PhotoCarouselViewModel: ObservableObject {
    @Published var images: [Photo] = []
    private let photoService: PhotoServiceProtocol
    private let imageLoader: ImageLoader
    
    init(photoService: PhotoServiceProtocol, imageLoader: ImageLoader) {
        self.photoService = photoService
        self.imageLoader = imageLoader
    }
    
    func loadImages() async {
        do {
            let photos = try await self.photoService.fetchPhotos(page: 1, limit: 10)
            images = photos
        } catch {
            print("Error loading images")
        }
    }
    
    func fetchImage(photo: Photo) async -> UIImage? {
        do {
            let image = try await imageLoader.fetch(url: photo.downloadUrl)
            return image
        } catch {
            print("Error fetching image")
            return nil
        }
    }
}
