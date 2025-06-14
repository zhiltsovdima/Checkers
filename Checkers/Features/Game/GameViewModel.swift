//
//  GameViewModel.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 14.06.2025.
//

import Foundation
import Combine

import Combine

class GameViewModel: ObservableObject {
    @Published var game: CheckersGame
    @Published var possibleMoves: [Move] = []
    @Published var isHost: Bool
    @Published var isOpponentDisconnected: Bool = false
    private let multipeerManager = MultipeerManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(isHost: Bool) {
        self.isHost = isHost
        self.game = CheckersGame(isHost: isHost)
        setupNetworkObserver()
        setupGameObserver()
        setupPeerObserver()
    }
    
    private func setupNetworkObserver() {
        multipeerManager.$receivedMove
            .compactMap { $0 }
            .sink { [weak self] move in
                guard let self else { return }
                self.game.applyNetworkMove(move)
            }
            .store(in: &cancellables)
    }
    
    private func setupGameObserver() {
        game.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.possibleMoves = self.game.selectedPiece != nil ? self.game.validMoves(for: self.game.selectedPiece!) : []
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func setupPeerObserver() {
        multipeerManager.$connectedPeers
            .sink { [weak self] peers in
                guard let self else { return }
                print("Connected peers changed: \(peers.map { $0.displayName })")
                self.isOpponentDisconnected = peers.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func handleTap(row: Int, col: Int) {
        GameInteractionHandler.handleTap(
            row: row,
            col: col,
            game: game,
            possibleMoves: &possibleMoves,
            isHost: isHost,
            sendMove: { [weak self] move in
                self?.multipeerManager.sendMove(move)
            }
        )
    }
    
    func exitButtonTap() {
        cancellables.removeAll()
        if isHost {
            multipeerManager.stopHosting()
        } else {
            multipeerManager.stopBrowsing()
        }
        multipeerManager.connectedPeers.forEach { peer in
            multipeerManager.session.disconnect()
        }
    }
}
