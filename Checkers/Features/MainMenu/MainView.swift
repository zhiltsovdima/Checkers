//
//  MainView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var coordinator: MainCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Text("Russian Checkers")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom)
                    ForEach(MainCoordinator.MainMenuItem.allCases) { item in
                        ActionAccentButton(title: item.localizedName) {
                            coordinator.push(item.associatedScreen)
                        }
                    }
                    .frame(width: 300)
                }
            }
            .navigationDestination(for: MainCoordinator.Screen.self) { screen in
                coordinator.build(screen: screen)
            }
        }
    }
}

#Preview {
    MainView(coordinator: MainCoordinator())
}
