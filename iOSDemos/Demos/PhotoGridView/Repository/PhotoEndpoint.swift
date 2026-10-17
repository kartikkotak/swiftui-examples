//
//  PhotoEndpoint.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
}

public enum PhotoEndpoint: Endpoint {
    case fetchImages(limit: Int, page: Int)
    case downloadThumbnailImage(id: String)
    
    public var baseURL: String {
        return "https://picsum.photos"
    }
    
    public var path: String {
        switch self {
        case .fetchImages(let limit, let page):
            return "\(baseURL)/v2/list?page:\(page)&limit:\(limit)"
        case .downloadThumbnailImage(let id):
            return "\(baseURL)/id/\(id)/200/300"
        }
    }
}
