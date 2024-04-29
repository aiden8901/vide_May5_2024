//
//  DeveloperView.swift
//  vide
//
//  Created by Howon Kim on 4/20/24.
//

import SwiftUI

struct DeveloperView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        
        VStack {
            Toggle("My Boolean Setting", isOn: $userSettings.isSetup)
                .padding()
            Text(userSettings.isSetup.description)
        }
    }
}

#Preview {
    DeveloperView()
}
