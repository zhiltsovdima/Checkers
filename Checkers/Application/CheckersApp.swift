//
//  CheckersApp.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

@main
struct CheckersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    private var rootCoordinator = RootCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView(rootCoordinator: rootCoordinator)
        }
    }
}
