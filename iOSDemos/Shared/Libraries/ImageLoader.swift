//
//  ImageLoader.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import UIKit

protocol ImageLoaderProtocol {
    func fetch(url: String) async throws -> UIImage
}

actor ImageLoader: ImageLoaderProtocol {
    private let imageCache = ImageCacher<NSString, UIImage>(countLimit: 200)
    
    private let session: URLSession
    
    private var runningTasks: [String: Task<UIImage, Error>] = [:]
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(url: String) async throws -> UIImage {
        // Return cached image if available
        if let image = await imageCache.object(for: NSString(string: url)) {
            return image
        }
        
        if let existingTask = runningTasks[url] {
            return try await existingTask.value
        }
        
        let task = Task<UIImage, Error>(priority: .userInitiated) { [session, weak self] in
            guard let urlObj = URL(string: url) else {
                throw URLError(.badURL)
            }
            let (data, response) = try await session.data(from: urlObj)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw URLError(.badServerResponse)
            }
            
            let image = try await Task.detached(priority: .utility) {
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                await self?.imageCache.set(image, for: .init(string: url))
                return image
            }.value
            
            return image
        }
        
        runningTasks[url] = task
        
        defer { runningTasks[url] = nil }
        
        return try await task.value
    }
}
