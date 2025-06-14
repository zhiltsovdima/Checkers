//
//  MainCoordinator.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    var isHost: Bool = false
        
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func exitGame() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .mainMenu:
            MainView(coordinator: self)
        case .lobby:
            LobbyView(coordinator: self)
        case .settings:
            SettingsView()
        case .info:
            InfoView()
        case .game:
            let viewModel = GameViewModel(isHost: isHost)
            GameView(coordinator: self, viewModel: viewModel)
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
        
        case game
                
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
            case .game:
                return "Game"
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
