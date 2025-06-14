//
//  LobbyView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct LobbyView: View {
    @ObservedObject var coordinator: MainCoordinator
    @ObservedObject var multipeerManager = MultipeerManager.shared
    @State private var showJoinView = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Lobby")
                    .foregroundColor(.black)
                    .font(.title)
                    .padding()
                
                if multipeerManager.isWaitingForConnection {
                    VStack {
                        ProgressView("Waiting for connection...")
                            .padding()
                            .foregroundColor(.black)
                        
                        ActionAccentButton(
                            title: "Stop"
                        ) {
                            multipeerManager.stopHosting()
                        }
                        .padding()
                    }
                } else {
                    ActionAccentButton(
                        title: "Create a game"
                    ) {
                        coordinator.isHost = true
                        multipeerManager.startHosting()
                    }
                    
                    ActionAccentButton(
                        title: "Join"
                    ) {
                        coordinator.isHost = false
                        multipeerManager.startBrowsing()
                        showJoinView = true
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showJoinView) {
            JoinView(checkersSession: multipeerManager)
        }
        .onChange(of: multipeerManager.connectedPeers) { newPeers in
            if !newPeers.isEmpty {
                coordinator.push(.game)
            }
        }
    }
}

#Preview {
    LobbyView(coordinator: MainCoordinator())
}
