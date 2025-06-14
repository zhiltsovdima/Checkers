//
//  JoinView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 14.06.2025.
//

import SwiftUI

struct JoinView: View {
    @ObservedObject var checkersSession: MultipeerManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if checkersSession.discoveredPeers.isEmpty {
                    searchingForDevices
                } else {
                    listOfDevices
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        checkersSession.stopBrowsing()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var searchingForDevices: some View {
        ProgressView("Search devices...")
            .padding()
    }
    
    private var listOfDevices: some View {
        VStack {
            Text("Choose device")
                .font(.headline)
            List(checkersSession.discoveredPeers, id: \.self) { peer in
                Button {
                    checkersSession.connectToPeer(peer)
                    dismiss()
                } label: {
                    Text(peer.displayName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    JoinView(checkersSession: MultipeerManager.shared)
}
