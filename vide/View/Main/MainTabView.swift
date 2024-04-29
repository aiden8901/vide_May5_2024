//
//  MainTabView.swift
//  vide
//
//  Created by Howon Kim on 4/20/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var userSettings = UserSettings()
    private var showDeveloperSetting = true
    
    var body: some View {
        Group {
            TabView {
                if (userSettings.isSetup) {
                    SetupView()
                        .environmentObject(userSettings)
                        .tabItem {
                            Image(systemName: "2.square.fill")
                            Text("Second")
                        }
                        .toolbar(.hidden, for: .tabBar)
                }
                
                FeedView()
                    .environmentObject(userSettings)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(Color(hex: 0x171C87))
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("Routine")
                    }

                
                if (showDeveloperSetting) {
                    DeveloperView()
                        .environmentObject(userSettings)
                        .tabItem {
                            Image(systemName: "gear")
                                .foregroundColor(.red)
                            Text("DEV")
                        }
                }
            } //:TABVIEW
        }
    }
}

#Preview {
    MainTabView()
}
