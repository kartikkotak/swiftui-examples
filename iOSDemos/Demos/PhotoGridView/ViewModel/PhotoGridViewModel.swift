//
//  PhotoGridViewModel.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import SwiftUI
import Combine

@MainActor
class PhotoGridViewModel: ObservableObject {
    
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false
    @Published var fetchMore: Bool = false
    
    private var page: Int = 0
    private let limit: Int = 15
    private var disposeBag: Set<AnyCancellable> = []
    private let photoRepository: PhotoServiceProtocol
    private let imageLoader: ImageLoaderProtocol
    
    init(photoRepository: PhotoServiceProtocol, imageLoader: ImageLoaderProtocol) {
        self.photoRepository = photoRepository
        self.imageLoader = imageLoader
    }
    
    public func fetchPhotoImage(_ photo: Photo) async -> UIImage? {
        do {
            let image = try await imageLoader.fetch(url: PhotoEndpoint.downloadThumbnailImage(id: photo.id).path)
            return image
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func refresh() async {
        page = 0
        await loadInitialPhotos(refresh: true)
    }
    
    public func fetchMoreImages() async {
        page += 1
        do {
            try await fetchPhotos()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func loadInitialPhotos(refresh: Bool = false) async {
        if photos.isEmpty || refresh {
            do {
                try await fetchPhotos(refresh: refresh)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchPhotos(refresh: Bool = false) async throws {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        do {
            let newPhotos = try await self.photoRepository.fetchPhotos(page: page, limit: limit)
            Task { @MainActor [weak self] in
                if refresh {
                    self?.photos = newPhotos
                } else {
                    self?.photos.append(contentsOf: newPhotos)
                }
                self?.isLoading = false
            }
        } catch {
            self.isLoading = false
            print("Failed to fetch photos")
        }
    }
}
