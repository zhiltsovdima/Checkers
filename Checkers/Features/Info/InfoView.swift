//
//  InfoView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Russian Checkers Rules")
                .font(.title)
                .padding()

            Text("""
            • **Board & Setup**: Played on an 8x8 board with 12 pieces per player. White pieces start on rows 1–3, black on rows 5–8. Only dark squares are used.
            • **Movement**: Pieces move diagonally forward one square. Kings move any number of squares diagonally (forward or backward).
            • **Capturing**: If an opponent’s piece is adjacent and the next square is empty, you must jump over and capture it. Multiple captures in one turn are allowed if possible. Capturing is mandatory.
            • **Promotion**: A piece reaching the opponent’s back row (row 8 for white, row 1 for black) becomes a king.
            • **Winning**: The game ends when a player captures all opponent pieces or blocks them from moving. A draw occurs if neither can win.
            """)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .navigationTitle("About Game")
    }
}

#Preview {
    InfoView()
}
