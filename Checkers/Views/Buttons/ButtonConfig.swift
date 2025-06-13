//
//  ButtonConfig.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct ButtonConfig {
    let fontSelected: Font
    let fontUnselected: Font
    
    let enabledColor: Color
    let disabledColor: Color
    
    let titleColorSelected: Color
    let titleColorUnselected: Color
    
    let systemImageName: String?
    let imageName: String?
    let spacing: CGFloat?
    let hPadding: CGFloat?
    let vPadding: CGFloat?
    
    let cornerRadius: CGFloat
    
    init(
        fontSelected: Font = .system(size: 17, weight: .medium),
        fontUnselected: Font = .system(size: 17, weight: .medium),
        enabledColor: Color = .init(red: 0.2, green: 0.2, blue: 0.25),
        disabledColor: Color = .gray.opacity(0.3),
        titleColorSelected: Color = .white,
        titleColorUnselected: Color = .init(red: 0.8, green: 0.8, blue: 0.85),
        systemImageName: String? = nil,
        imageName: String? = nil,
        spacing: CGFloat? = 4,
        hPadding: CGFloat? = 16,
        vPadding: CGFloat? = 14,
        cornerRadius: CGFloat = 12
    ) {
        self.fontSelected = fontSelected
        self.fontUnselected = fontUnselected
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
        self.titleColorSelected = titleColorSelected
        self.titleColorUnselected = titleColorUnselected
        self.systemImageName = systemImageName
        self.imageName = imageName
        self.spacing = spacing
        self.hPadding = hPadding
        self.vPadding = vPadding
        self.cornerRadius = cornerRadius
    }
    
    enum Accent {
        static let regular: ButtonConfig = .init()
    }
}
