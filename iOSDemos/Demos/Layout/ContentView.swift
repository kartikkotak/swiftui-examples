//
//  ContentView.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                Section("Image Loading and Caching") {
                    ContentCellView(content: {
                        Text("Lazy Photo Grid")
                    })
                    .onTapGesture {
                        router.showPhotoGridView()
                    }
                    ContentCellView {
                        Text("Photo carousel")
                    }
                    .onTapGesture {
                        router.path.append(Route.photoCarouselView)
                    }
                }
                
                Section("Carousels") {
                    ContentCellView {
                        Text("Peeking Carousel View")
                    }
                    .onTapGesture {
                        router.path.append(Route.peekingCarouselView)
                    }
                }
            }
            .environmentObject(router)
            .navigationTitle("iOS Demo List")
            .navigationDestination(for: Route.self) { route in
                router.navigate(route)
            }
        }
    }
}

struct ContentCellView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    var body: some View {
        content()
            .frame(maxWidth:.infinity, alignment: .leading)
            .contentShape(Rectangle())
    }
}

#Preview {
    ContentCellView {
        Text("Dummy text")
    }
}

#Preview {
    ContentView()
}
