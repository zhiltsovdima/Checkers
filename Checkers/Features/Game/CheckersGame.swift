//
//  CheckersGame.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import Foundation
import SwiftUI

// MARK: - Models
enum PieceType: String, Codable {
    case white
    case black
    case whiteKing
    case blackKing
}

enum Player {
    case white
    case black
}

struct Piece: Identifiable, Codable, Equatable {
    var id = UUID()
    let type: PieceType
    let row: Int
    let col: Int
}

struct Move: Codable {
    let from: (row: Int, col: Int)
    let to: (row: Int, col: Int)
    let captured: [(row: Int, col: Int)]
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case fromRow, fromCol, toRow, toCol, captured, type
    }
    
    init(from: (row: Int, col: Int), to: (row: Int, col: Int), captured: [(row: Int, col: Int)], type: String) {
        self.from = from
        self.to = to
        self.captured = captured
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fromRow = try container.decode(Int.self, forKey: .fromRow)
        let fromCol = try container.decode(Int.self, forKey: .fromCol)
        let toRow = try container.decode(Int.self, forKey: .toRow)
        let toCol = try container.decode(Int.self, forKey: .toCol)
        let capturedCoordinates = try container.decode([[Int]].self, forKey: .captured)
        self.from = (fromRow, fromCol)
        self.to = (toRow, toCol)
        self.captured = capturedCoordinates.map { ($0[0], $0[1]) }
        self.type = try container.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from.row, forKey: .fromRow)
        try container.encode(from.col, forKey: .fromCol)
        try container.encode(to.row, forKey: .toRow)
        try container.encode(to.col, forKey: .toCol)
        let capturedCoordinates = captured.map { [$0.row, $0.col] }
        try container.encode(capturedCoordinates, forKey: .captured)
        try container.encode(type, forKey: .type)
    }
}

// MARK: - CheckersGame
class CheckersGame: ObservableObject {
    @Published var board: [[Piece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    @Published var currentPlayer: Player = .white
    @Published var selectedPiece: Piece?
    @Published var gameOver: Bool = false
    @Published var winner: Player?
    var isHost: Bool
    
    init(isHost: Bool = false) {
        self.isHost = isHost
        setupBoard()
    }
    
    func setupBoard() {
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        for row in 0...2 {
            for col in 0..<8 {
                if (row + col) % 2 == 1 {
                    board[row][col] = Piece(type: .white, row: row, col: col)
                }
            }
        }
        for row in 5...7 {
            for col in 0..<8 {
                if (row + col) % 2 == 1 {
                    board[row][col] = Piece(type: .black, row: row, col: col)
                }
            }
        }
    }
    
    func validMoves(for piece: Piece) -> [Move] {
        let isWhitePiece = piece.type == .white || piece.type == .whiteKing
        let isCurrentPlayerPiece = (isWhitePiece && currentPlayer == .white) || (!isWhitePiece && currentPlayer == .black)
        guard isCurrentPlayerPiece else {
            return []
        }
        
        if mustCapture() {
            return captureMoves(for: piece)
        } else {
            return regularMoves(for: piece)
        }
    }
    
    private func regularMoves(for piece: Piece) -> [Move] {
        var moves: [Move] = []
        let isWhite = piece.type == .white || piece.type == .whiteKing
        let isKing = piece.type == .whiteKing || piece.type == .blackKing
        let directions = isKing ? [(-1, -1), (-1, 1), (1, -1), (1, 1)] :
            isWhite ? [(1, -1), (1, 1)] : [(-1, -1), (-1, 1)]
        
        for (dr, dc) in directions {
            if isKing {
                var step = 1
                while true {
                    let newRow = piece.row + dr * step
                    let newCol = piece.col + dc * step
                    if !isValidPosition(row: newRow, col: newCol) || board[newRow][newCol] != nil {
                        break
                    }
                    moves.append(Move(from: (piece.row, piece.col), to: (newRow, newCol), captured: [], type: "move"))
                    step += 1
                }
            } else {
                let newRow = piece.row + dr
                let newCol = piece.col + dc
                if isValidPosition(row: newRow, col: newCol) && board[newRow][newCol] == nil {
                    moves.append(Move(from: (piece.row, piece.col), to: (newRow, newCol), captured: [], type: "move"))
                }
            }
        }
        
        return moves
    }
    
    private func captureMoves(for piece: Piece) -> [Move] {
        var results: [Move] = []
        let isWhite = piece.type == .white || piece.type == .whiteKing
        let isKing = piece.type == .whiteKing || piece.type == .blackKing
        
        func dfs(current: (row: Int, col: Int), captured: [(row: Int, col: Int)]) {
            results.append(Move(from: (piece.row, piece.col), to: current, captured: captured, type: "capture"))
            let directions = isKing ? [(-1, -1), (-1, 1), (1, -1), (1, 1)] : [(-1, -1), (-1, 1), (1, -1), (1, 1)]
            
            for (dr, dc) in directions {
                if isKing {
                    var step = 1
                    while isValidPosition(row: current.row + dr * step, col: current.col + dc * step) {
                        let midRow = current.row + dr * step
                        let midCol = current.col + dc * step
                        let landRow = midRow + dr
                        let landCol = midCol + dc
                        if isValidPosition(row: landRow, col: landCol),
                           let midPiece = board[midRow][midCol],
                           (midPiece.type == (isWhite ? .black : .white) || midPiece.type == (isWhite ? .blackKing : .whiteKing)),
                           board[landRow][landCol] == nil,
                           !captured.contains(where: { $0 == (midRow, midCol) }) {
                            dfs(current: (landRow, landCol), captured: captured + [(midRow, midCol)])
                        }
                        if board[midRow][midCol] != nil { break }
                        step += 1
                    }
                } else {
                    let midRow = current.row + dr
                    let midCol = current.col + dc
                    let landRow = current.row + 2 * dr
                    let landCol = current.row + 2 * dc
                    if isValidPosition(row: midRow, col: midCol),
                       isValidPosition(row: landRow, col: landCol),
                       let midPiece = board[midRow][midCol],
                       (midPiece.type == (isWhite ? .black : .white) || midPiece.type == (isWhite ? .blackKing : .whiteKing)),
                       board[landRow][landCol] == nil,
                       !captured.contains(where: { $0 == (midRow, midCol) }) {
                        dfs(current: (landRow, landCol), captured: captured + [(midRow, midCol)])
                    }
                }
            }
        }
        
        if isKing {
            dfs(current: (piece.row, piece.col), captured: [])
        } else {
            let directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
            for (dr, dc) in directions {
                let midRow = piece.row + dr
                let midCol = piece.col + dc
                let landRow = piece.row + 2 * dr
                let landCol = piece.col + 2 * dc
                if isValidPosition(row: midRow, col: midCol),
                   isValidPosition(row: landRow, col: landCol),
                   let midPiece = board[midRow][midCol],
                   (midPiece.type == (isWhite ? .black : .white) || midPiece.type == (isWhite ? .blackKing : .whiteKing)),
                   board[landRow][landCol] == nil {
                    dfs(current: (landRow, landCol), captured: [(midRow, midCol)])
                }
            }
        }
        
        return results.filter { !$0.captured.isEmpty }
    }
    
    private func mustCapture() -> Bool {
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = board[row][col],
                   ((piece.type == .white || piece.type == .whiteKing) && currentPlayer == .white) ||
                   ((piece.type == .black || piece.type == .blackKing) && currentPlayer == .black) {
                    if !captureMoves(for: piece).isEmpty {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func makeMove(_ move: Move) {
        guard let piece = board[move.from.row][move.from.col] else {
            return
        }
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.board[move.from.row][move.from.col] = nil
            let newType = self.shouldPromoteToKing(piece: piece, at: move.to) ? (piece.type == .white ? .whiteKing : .blackKing) : piece.type
            let newPiece = Piece(type: newType, row: move.to.row, col: move.to.col)
            self.board[move.to.row][move.to.col] = newPiece
            
            for (row, col) in move.captured {
                self.board[row][col] = nil
            }
            
            let canCaptureAgain = !self.captureMoves(for: newPiece).isEmpty
            if !canCaptureAgain || move.type == "move" {
                self.currentPlayer = self.currentPlayer == .white ? .black : .white
                self.selectedPiece = nil
            } else {
                self.selectedPiece = newPiece
            }
            
            self.checkGameOver()
        }
    }
    
    func applyNetworkMove(_ move: Move) {
        makeMove(move)
    }
    
    private func shouldPromoteToKing(piece: Piece, at position: (row: Int, col: Int)) -> Bool {
        if piece.type == .white && position.row == 7 {
            return true
        }
        if piece.type == .black && position.row == 0 {
            return true
        }
        return false
    }
    
    private func isValidPosition(row: Int, col: Int) -> Bool {
        return row >= 0 && row < 8 && col >= 0 && col < 8 && (row + col) % 2 == 1
    }
    
    private func checkGameOver() {
        let whitePieces = board.flatMap { $0 }.compactMap { $0 }.filter { $0.type == .white || $0.type == .whiteKing }
        let blackPieces = board.flatMap { $0 }.compactMap { $0 }.filter { $0.type == .black || $0.type == .blackKing }
        
        if whitePieces.isEmpty {
            gameOver = true
            winner = .black
        } else if blackPieces.isEmpty {
            gameOver = true
            winner = .white
        } else {
            let whiteHasMoves = whitePieces.contains { !validMoves(for: $0).isEmpty }
            let blackHasMoves = blackPieces.contains { !validMoves(for: $0).isEmpty }
            if !whiteHasMoves && currentPlayer == .white {
                gameOver = true
                winner = blackHasMoves ? .black : nil
            } else if !blackHasMoves && currentPlayer == .black {
                gameOver = true
                winner = whiteHasMoves ? .white : nil
            }
        }
    }
}
