//
//  MainCoordinator.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()
        
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .mainMenu:
            MainView(coordinator: self)
        case .lobby:
            LobbyView()
        case .settings:
            SettingsView()
        case .info:
            InfoView()
        }
    }
}

// MARK: - Screen & MainMenuItem
extension MainCoordinator {
    
    enum Screen: String {
        case mainMenu
        case lobby
        case settings
        case info
                
        var localizedName: String {
            switch self {
            case .mainMenu:
                return "Main menu"
            case .lobby:
                return "Lobby"
            case .settings:
                return "Settings"
            case .info:
                return "Info"
            }
        }
    }
    
    enum MainMenuItem: String, Identifiable, CaseIterable {
        case newGame
        case settings
        case info
        
        var id: String { rawValue }
        
        var localizedName: String {
            switch self {
            case .newGame:
                return "New game"
            case .settings:
                return "Settings"
            case .info:
                return "Info"
            }
        }
        
        var associatedScreen: Screen {
            switch self {
            case .newGame:
                return .lobby
            case .settings:
                return .settings
            case .info:
                return .info
            }
        }
    }
}
