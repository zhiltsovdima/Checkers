//
//  RootView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootCoordinator: RootCoordinator
    
    private let mainCoordinator = MainCoordinator()
    
    var body: some View {
        Group {
            switch rootCoordinator.currentFlow {
            case .main:
                MainView(coordinator: mainCoordinator)
            }
        }
        .animation(.default, value: rootCoordinator.currentFlow)
    }
}

#Preview {
    RootView(rootCoordinator: RootCoordinator())
}
