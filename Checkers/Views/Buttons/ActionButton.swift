//
//  ActionButton.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct ActionAccentButton: View {
    
    let title: String
    let isEnabled: Bool
    let isSelected: Bool
    
    let titleColor: Color
    let activeColor: Color
    let inactiveColor: Color
    
    let selectedFont: Font
    let unselectedFont: Font
    
    let systemImageName: String?
    let imageName: String?
    let elementsSpacing: CGFloat?
    
    let cornerRadius: CGFloat
    let horizontalPadding: CGFloat?
    let verticalPadding: CGFloat?

    let action: () -> Void

    var currentColor: Color {
        isEnabled ? activeColor : inactiveColor
    }
    
    var currentFont: Font {
        isSelected ? selectedFont : unselectedFont
    }
    
    init(
        title: String = "",
        isEnabled: Bool = true,
        isSelected: Bool = true,
        config: ButtonConfig = .Accent.regular,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        
        self.titleColor = isSelected ? config.titleColorSelected : config.titleColorUnselected
        self.activeColor = config.enabledColor
        self.inactiveColor = config.disabledColor
        
        self.selectedFont = config.fontSelected
        self.unselectedFont = config.fontUnselected
        
        self.systemImageName = config.systemImageName
        self.imageName = config.imageName
        self.elementsSpacing = config.spacing
        self.cornerRadius = config.cornerRadius
        self.horizontalPadding = config.hPadding
        self.verticalPadding = config.vPadding
        self.action = action
    }
    
    var body: some View {
        Button {
            guard isEnabled else { return }
            action()
        } label: {
            HStack(spacing: elementsSpacing) {
                if let imageName {
                    Image(imageName)
                } else if let systemImageName {
                    Image(systemName: systemImageName)
                }
                if !title.isEmpty {
                    Text(title)
                        .font(currentFont)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(currentColor)
            .contentShape(Rectangle())
        }
        .cornerRadius(cornerRadius)
        .foregroundColor(titleColor)
        .animation(.easeInOut, value: isEnabled)
        .buttonStyle(.plain)
    }
}

#Preview {
    ActionAccentButton(
        title: "Play",
        config: .Accent.regular
    ) { }
}
