//
//  ThemeManager.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI
import Combine

enum ThemeOption: String, CaseIterable, Identifiable {
    case sandy = "Sandy"
    case blue = "Blue"
    case red = "Red"
    
    var id: String { rawValue }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var selectedTheme: ThemeOption {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "SelectedTheme")
        }
    }
    
    private init() {
        let savedThemeRawValue = UserDefaults.standard.string(forKey: "SelectedTheme") ?? ThemeOption.sandy.rawValue
        self.selectedTheme = ThemeOption(rawValue: savedThemeRawValue) ?? .sandy
    }
    
    var lightCellColor: Color {
        switch selectedTheme {
        case .sandy: return Color(hex: "#F5E6CC")
        case .blue: return Color(hex: "#E6F3FF")
        case .red: return Color(hex: "#FFE6E6")
        }
    }
    
    var darkCellColor: Color {
        switch selectedTheme {
        case .sandy: return Color(hex: "#4A4A4A")
        case .blue: return Color(hex: "#1E3A8A")
        case .red: return Color(hex: "#7F1D1D")
        }
    }
    
    var textColor: Color {
        switch selectedTheme {
        case .sandy: return Color(hex: "#333333")
        case .blue: return Color(hex: "#1E40AF")
        case .red: return Color(hex: "#991B1B")
        }
    }
    
    var whitePieceGradient: LinearGradient {
        switch selectedTheme {
        case .sandy:
            return LinearGradient(
                colors: [.white, Color(hex: "#D3D3D3")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .blue:
            return LinearGradient(
                colors: [.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .red:
            return LinearGradient(
                colors: [.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var blackPieceGradient: LinearGradient {
        switch selectedTheme {
        case .sandy:
            return LinearGradient(
                colors: [.black, Color(hex: "#333333")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .blue:
            return LinearGradient(
                colors: [.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .red:
            return LinearGradient(
                colors: [.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
