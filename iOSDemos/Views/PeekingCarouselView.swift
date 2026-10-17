//
//  PeekingCarouselView.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/11/26.
//

import SwiftUI

struct CarouselItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
}

struct PeekingCarouselView: View {
    let items: [CarouselItem] = [
        CarouselItem(title: "Explore Nature", subtitle: "12 Trails Nearby", color: .emeraldGreen),
        CarouselItem(title: "Urban Spaces", subtitle: "Top City Spots", color: .deepPurple),
        CarouselItem(title: "Ocean Breeze", subtitle: "8 Coastal Views", color: .oceanBlue),
        CarouselItem(title: "Mountain Peaks", subtitle: "Summit Guides", color: .sunsetOrange)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(items) { item in
                    CardView(item: item)
                    // Make each card fill the container width minus the margins
                        .containerRelativeFrame(.horizontal, alignment: .leading)
                    // Add smooth depth scaling as cards enter/leave center
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.92)
                                .opacity(phase.isIdentity ? 1.0 : 0.6)
                        }
                }
            }
            .scrollTargetLayout()
        }
        // Inset horizontal content to allow previous/next cards to peek in
        .contentMargins(.horizontal, 24, for: .scrollContent)
        // Enable snapping to individual items
        .scrollTargetBehavior(.viewAligned)
    }
}

struct CardView: View {
    let item: CarouselItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(.title2)
                .fontWeight(.bold)
            Text(item.subtitle)
                .font(.subheadline)
                .opacity(0.8)
            Spacer()
        }
        .padding(24)
        .frame(height: 220)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(item.color.gradient)
        .foregroundColor(.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// Helper colors for the sample cards
extension Color {
    static let emeraldGreen = Color(red: 0.1, green: 0.6, blue: 0.4)
    static let deepPurple   = Color(red: 0.4, green: 0.2, blue: 0.6)
    static let oceanBlue    = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let sunsetOrange = Color(red: 0.9, green: 0.4, blue: 0.2)
}

#Preview {
    PeekingCarouselView()
}
