//
//  GameView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ThemeManager.shared.lightCellColor,
                    ThemeManager.shared.darkCellColor
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                StatusView(
                    currentPlayer: viewModel.game.currentPlayer,
                    isGameOver: viewModel.game.gameOver,
                    winner: viewModel.game.winner,
                    isHost: viewModel.isHost
                )
                
                BoardView(
                    board: viewModel.game.board,
                    selectedPiece: viewModel.game.selectedPiece,
                    possibleMoves: viewModel.possibleMoves,
                    isHost: viewModel.isHost,
                    onSquareTapped: { row, col in
                        viewModel.handleTap(row: row, col: col)
                    }
                )
                
                ActionAccentButton(title: "Exit") {
                    viewModel.exitButtonTap()
                    coordinator.exitGame()
                }
            }
            .padding()
            .alert("Opponent Disconnected", isPresented: $viewModel.isOpponentDisconnected) {
                Button("Back to Main Menu") {
                    viewModel.exitButtonTap()
                    coordinator.exitGame()
                }
            } message: {
                Text("The other player has left the game.")
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct BoardView: View {
    let board: [[Piece?]]
    let selectedPiece: Piece?
    let possibleMoves: [Move]
    let isHost: Bool
    let onSquareTapped: (Int, Int) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(GameConstants.boardSize)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.fixed(cellSize), spacing: 0),
                    count: GameConstants.boardSize),
                spacing: 0
            ) {
                let rowIndices = isHost ? Array((0..<GameConstants.boardSize).reversed()) : Array(0..<GameConstants.boardSize)
                let colIndices = isHost ? Array(0..<GameConstants.boardSize) : Array((0..<GameConstants.boardSize).reversed())
                
                ForEach(rowIndices, id: \.self) { row in
                    ForEach(colIndices, id: \.self) { col in
                        let isDarkSquare = (row + col) % 2 == 1
                        let displayRow = isHost ? row : (GameConstants.boardSize - 1 - row)
                        let displayCol = isHost ? col : (GameConstants.boardSize - 1 - col)
                        
                        if isDarkSquare {
                            CheckersSquare(
                                piece: board[displayRow][displayCol],
                                row: displayRow,
                                col: displayCol,
                                isSelected: selectedPiece?.row == displayRow && selectedPiece?.col == displayCol,
                                isMoveTarget: possibleMoves.contains { $0.to == (displayRow, displayCol) },
                                cellSize: cellSize,
                                isRotated: !isHost,
                                onTap: { onSquareTapped(displayRow, displayCol) }
                            )
                        } else {
                            ThemeManager.shared.lightCellColor
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
            .rotationEffect(.degrees(isHost ? 0 : 180))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct CheckersSquare: View {
    let piece: Piece?
    let row: Int
    let col: Int
    let isSelected: Bool
    let isMoveTarget: Bool
    let cellSize: CGFloat
    let isRotated: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                ThemeManager.shared.darkCellColor
                if isMoveTarget {
                    GameConstants.moveTargetColor
                }
                if isSelected {
                    GameConstants.selectedSquareColor
                }
                if let piece = piece {
                    PieceView(piece: piece, cellSize: cellSize)
                        .rotationEffect(.degrees(isRotated ? 180 : 0))
                }
            }
            .frame(width: cellSize, height: cellSize)
        }
    }
}

struct PieceView: View {
    let piece: Piece
    let cellSize: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    piece.type == .white || piece.type == .whiteKing
                    ? ThemeManager.shared.whitePieceGradient
                    : ThemeManager.shared.blackPieceGradient
                )
                .frame(width: cellSize * 0.8, height: cellSize * 0.8)
                .shadow(radius: GameConstants.pieceShadowRadius)
            
            if piece.type == .whiteKing || piece.type == .blackKing {
                Image(systemName: "crown.fill")
                    .foregroundColor(piece.type == .whiteKing ? .black : .yellow)
                    .font(.system(size: cellSize * 0.3))
            }
        }
    }
}

struct StatusView: View {
    let currentPlayer: Player
    let isGameOver: Bool
    let winner: Player?
    let isHost: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            let isPlayerTurn = (isHost && currentPlayer == .white) || (!isHost && currentPlayer == .black)
            Text(isPlayerTurn ? "Your Turn" : "Opponent's Turn")
                .font(.system(.title2, weight: .medium))
                .foregroundColor(ThemeManager.shared.textColor)
            
            if isGameOver {
                Text(winner == .white ? "White Wins!" : winner == .black ? "Black Wins!" : "Draw!")
                    .font(.system(.title, weight: .bold))
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

struct GameInteractionHandler {
    static func handleTap(row: Int, col: Int, game: CheckersGame, possibleMoves: inout [Move], isHost: Bool, sendMove: (Move) -> Void) {
        // Проверяем, ходит ли текущий игрок
        let isPlayerTurn = (isHost && game.currentPlayer == .white) || (!isHost && game.currentPlayer == .black)
        guard isPlayerTurn else { return }
        
        if let _ = game.selectedPiece {
            if let move = possibleMoves.first(where: { $0.to == (row, col) }) {
                game.makeMove(move)
                sendMove(move)
                possibleMoves = game.selectedPiece != nil ? game.validMoves(for: game.selectedPiece!) : []
            } else if let piece = game.board[row][col] {
                let isWhitePiece = piece.type == .white || piece.type == .whiteKing
                let isCurrentPlayerPiece = (isWhitePiece && game.currentPlayer == .white) || (!isWhitePiece && game.currentPlayer == .black)
                if isCurrentPlayerPiece {
                    game.selectedPiece = piece
                    possibleMoves = game.validMoves(for: piece)
                } else {
                    game.selectedPiece = nil
                    possibleMoves = []
                }
            } else {
                game.selectedPiece = nil
                possibleMoves = []
            }
        } else if let piece = game.board[row][col] {
            let isWhitePiece = piece.type == .white || piece.type == .whiteKing
            let isCurrentPlayerPiece = (isWhitePiece && game.currentPlayer == .white) || (!isWhitePiece && game.currentPlayer == .black)
            if isCurrentPlayerPiece {
                game.selectedPiece = piece
                possibleMoves = game.validMoves(for: piece)
            }
        }
    }
}

struct GameConstants {
    static let boardSize = 8
    static let selectedSquareColor = Color.blue.opacity(0.3)
    static let moveTargetColor = Color.green.opacity(0.4)
    static let pieceShadowRadius: CGFloat = 2
    static let buttonShadowRadius: CGFloat = 4
    static let animationDuration: Double = 0.2
}
