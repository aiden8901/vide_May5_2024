//
//  InstanceData.swift
//  vide
//
//  Created by Howon Kim on 4/20/24.
//

import Foundation
import SwiftUI
let tags = ["Wakeup", "Reading", "Shower", "Studying", "Gaming", "Meditation", "Workout", "Stretching", "Diary"]

class UserSettings: ObservableObject {
    @AppStorage("isSetup") var isSetup: Bool = true
    @AppStorage("taskAndTime") var taskAndTimeString: String = ""

    var taskAndTime: [String: Int] {
        get {
            if let data = taskAndTimeString.data(using: .utf8),
               let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
                return decoded
            }
            return [:]
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue),
               let jsonString = String(data: encoded, encoding: .utf8) {
                taskAndTimeString = jsonString
            }
        }
    }

    init() {
    }
}


extension UserSettings {
    static var mock: UserSettings {
        let userSettings = UserSettings()
        userSettings.taskAndTime = [
            "Wakeup": 30,
            "Reading": 45,
            "Shower": 15,
            "Studying": 90,
            "Gaming": 60,
            "Meditation": 20,
            "Workout": 45,
            "Stretching": 10,
            "Diary": 20
        ]
        return userSettings
    }
}
