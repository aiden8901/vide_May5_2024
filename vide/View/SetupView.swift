//
//  SetupView.swift
//  vide
//
//  Created by Howon Kim on 4/20/24.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedTab = 0
    @State private var selectedTime = Date()
    @State private var selectedTag = ""
    @State private var selectedMinutes = 0
    @State private var taskAndTime: [String: Int] = [:]

    var body: some View {
        TabView(selection: $selectedTab) {
            TimePickerView(selectedTab: $selectedTab, selectedTime: $selectedTime)
                .tag(0)
            
            TagsView(selectedTag: $selectedTag)
                .onChange(of: selectedTag) {
                    withAnimation {
                        selectedTab += 1
                    }
                }
                .tag(1)
            
            TimeSettingView(selectedMinutes: $selectedMinutes, selectedTab: $selectedTab)
                .tag(2)
            
            SummaryView(selectedTab: $selectedTab, selectedTag: $selectedTag, selectedMinutes: $selectedMinutes, selectedTime: $selectedTime, taskAndTime: $taskAndTime)
                .tag(3)
            
            ConfirmationView(selectedTab: $selectedTab, selectedTag: $selectedTag, selectedMinutes: $selectedMinutes, taskAndTime: $taskAndTime)
                .tag(4)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

// MARK: 0. BASE TIME VIEW
struct TimePickerView: View {
    @Binding var selectedTab: Int
    @Binding var selectedTime: Date
    @State private var showCheckmark = false
    
    var body: some View {
        ZStack {
            VStack {
                DatePicker("Select a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .frame(height: 200)
                
                Text("Selected time: \(formattedTime)")
                    .padding()
                
                Button(action: {
                    showCheckmark = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showCheckmark = false
                            selectedTab += 1
                        }
                    }
                }) {
                    Text("Confirm")
                }
                .padding()
            } //:VSTACK
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .opacity(showCheckmark ? 1.0 : 0.0)
                .scaleEffect(showCheckmark ? 2.0 : 0.0)
        } //:ZSTACK
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedTime)
    }
}


// MARK: 1. TAG VIEW
struct TagsView: View {
    @Binding var selectedTag: String
    
    var body: some View {
        TagView(selectedTag: $selectedTag, tags: tags)
    }
}

// MARK: 2. TIME SETTING VIEW
struct TimeSettingView: View {
    @Binding var selectedMinutes: Int
    @Binding var selectedTab: Int
    let minutesInterval = 5 // Change this to set the interval between selectable minutes
    
    var body: some View {
        VStack {
            Text("Selected Duration: \(selectedMinutes) minutes")
            
            Picker("", selection: $selectedMinutes) {
                ForEach(1 ..< 65 / minutesInterval) {
                    Text("\($0 * minutesInterval)").tag($0 * minutesInterval)
                }
            }
            .onAppear{
                selectedMinutes = 5
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 200)
            
            Button(action: {
                withAnimation {
                    selectedTab += 1
                }
            }) {
                Text("Next")
            }
            .padding()
        }
    }
}

// MARK: 3. SUMMARY VIEW
struct SummaryView: View {
    @Binding var selectedTab: Int
    @Binding var selectedTag: String
    @Binding var selectedMinutes: Int
    @Binding var selectedTime: Date
    @Binding var taskAndTime: [String: Int]
    @State private var showCheckmark = false
    
    var body: some View {
        ZStack {
            VStack {
                Text(selectedTag)
                Text("\(selectedMinutes)")
                
                Button(action: {
                    taskAndTime[selectedTag] = Int(selectedMinutes)
                    showCheckmark = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showCheckmark = false
                            selectedTab += 1
                        }
                    }
                }) {
                    Text("Confirm")
                }
                .padding()
            } //: VSTACK
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .opacity(showCheckmark ? 1.0 : 0.0)
                .scaleEffect(showCheckmark ? 2.0 : 0.0)
            
        } //:ZSTACK
    }
}


// MARK: 4. CONFIRMATION VIEW
struct ConfirmationView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var selectedTab: Int
    @Binding var selectedTag: String
    @Binding var selectedMinutes: Int
    @Binding var taskAndTime: [String: Int]
    @State private var showMessage = false

    
    var body: some View {
        ZStack {
            VStack {
                List(taskAndTime.sorted(by: { $0.value < $1.value }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
                
                Button(action: {
                    showMessage = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            //selectedTag = ""
                            selectedMinutes = 0
                            selectedTab = 1
                            showMessage = false
                        }
                    }
                }) {
                    Text("Do you want to create more activity")
                }
                .padding()
                
                Button(action: {
                    withAnimation {
                        userSettings.taskAndTime = taskAndTime
                        userSettings.isSetup = false
                    }
                }) {
                    Text("No I am ready to go")
                }
                .padding()
            } //:VSTACK
            Text(" Here We Go ")
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(.green)
                .opacity(showMessage ? 1.0 : 0.0)
                .scaleEffect(showMessage ? 2.0 : 0.0)
        } //:ZSTACK
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Hour:Minute format
        return formatter
    }
    
}
#Preview {
    SetupView()
}
