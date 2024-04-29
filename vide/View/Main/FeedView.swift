//
//  FeedView.swift
//  vide
//
//  Created by Howon Kim on 4/20/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0

    
    var body: some View {
        VStack {
            Text("Elapsed Time: \(Int(elapsedTime)) seconds")
                            .font(.headline)
                            .padding()

                        Button(action: {
                            if self.startTime == nil {
                                // Start the timer
                                self.startTime = Date()
                                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    self.elapsedTime = Date().timeIntervalSince(self.startTime ?? Date())
                                }
                            } else {
                                // Stop the timer
                                self.timer?.invalidate()
                                self.timer = nil
                                self.startTime = nil
                                self.elapsedTime = 0
                            }
                        }) {
                            Text(self.startTime == nil ? "Start" : "Stop")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(self.startTime == nil ? Color.blue : Color.red)
                                .cornerRadius(10)
                        }
                
            ForEach(userSettings.taskAndTime.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Text("\(key): \(value) minutes")
            }
            ForEach(Array(userSettings.taskAndTime.keys.enumerated()), id: \.offset) { index, key in
                            if let value = userSettings.taskAndTime[key] {
                                Text("\(index + 1): \(value)")
                            }
                        }
            // CHANGE TO TWO LIST SAVING ORDER
        }
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Hour:Minute format
        return formatter
    }
}

#Preview {
    FeedView()
        .environmentObject(UserSettings.mock)
}
