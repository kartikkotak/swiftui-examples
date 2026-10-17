//
//  PhotoService.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import Foundation

protocol PhotoServiceProtocol: Sendable {
    func fetchPhotos(page: Int, limit: Int) async throws -> [Photo]
}

enum PhotoServiceError: Error {
    case badURL
    case badResponse
    case decodingError
    case failed
}

class PhotoService: PhotoServiceProtocol {
    
    private var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60.0
        config.timeoutIntervalForRequest = 60.0
        
        return URLSession(configuration: config)
    }
    
    func fetchPhotos(page: Int, limit: Int) async throws -> [Photo] {
        let urlString = PhotoEndpoint.fetchImages(limit: limit, page: page).path
        
        guard let url = URL(string: urlString) else {
            throw PhotoServiceError.badURL
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw PhotoServiceError.failed
            }
            
            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let photos: [Photo] = try decoder.decode([Photo].self, from: data)
                return photos
            } catch {
                throw PhotoServiceError.decodingError
            }
            
        } catch {
            throw PhotoServiceError.badResponse
        }
    }
}
