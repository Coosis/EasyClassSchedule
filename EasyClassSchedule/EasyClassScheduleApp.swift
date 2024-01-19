//
//  EasyClassScheduleApp.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

@main
struct EasyClassScheduleApp: App {
    @StateObject var store = ScheduleStore()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    var body: some Scene {
        WindowGroup {
            ContentView(){
                Task {
                    do {
                        try await store.save()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
                .environmentObject(store)
                .task {
                    do {
                        try await store.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .onAppear{
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                                if settings.authorizationStatus == .notDetermined {
                                    // Request permission
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                                        if let error = error {
                                            // Handle the error here
                                            alertMessage = "Error: \(error.localizedDescription)"
                                            showingAlert = true
                                        } else if !granted {
                                            // Handle the case where permission is not granted
                                            alertMessage = "Notifications permission was not granted."
                                            showingAlert = true
                                        } else {
                                            // Permission was granted
                                        }
                                    }
                                }
                            }
                }
        }
    }
}
