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
        }
    }
}
