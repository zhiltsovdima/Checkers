//
//  ThemeManager.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {}
    
    let lightCellColor = Color(hex: "#F5E6CC")
    let darkCellColor = Color(hex: "#4A4A4A")
    
    let textColor = Color(hex: "#333333")
    
    let whitePieceGradient = LinearGradient(
        colors: [.white, Color(hex: "#D3D3D3")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    let blackPieceGradient = LinearGradient(
        colors: [.black, Color(hex: "#333333")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
