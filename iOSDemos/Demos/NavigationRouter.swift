//
//  Route.swift
//  iOSDemos
//
//  Created by Kartik Kotak on 8/2/26.
//

import SwiftUI
import Combine

enum Route: Hashable {
    case photoGridView
    case photoCarouselView
    case peekingCarouselView
}

@MainActor
final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func showPhotoGridView() {
        path.append(Route.photoGridView)
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(_ route: Route) -> some View {
        switch route {
        case .photoGridView:
            PhotoGridView()
        case .photoCarouselView:
            PhotoCarouselView()
        case .peekingCarouselView:
            PeekingCarouselView()
        }
    }
}
