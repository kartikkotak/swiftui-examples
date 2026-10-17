//
//  Photo.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

struct Photo: Codable, Hashable, Identifiable {
    let id: String
    let author: String
    let width: Double
    let height: Double
    let downloadUrl: String
}
