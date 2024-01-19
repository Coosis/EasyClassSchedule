//
//  ContentView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store : ScheduleStore
    @State var editingSchedule : Bool = false
    @State var preferences : Preferences = Preferences()
    @State var timeTable : [SectionTime] = SectionTime.samples()
    @State var addingCurriculum : Bool = false
    @State var deleting : Bool = false
    @State var newCurriculum : Curriculum = Curriculum.newCurriculum()
    let saveAction: ()->Void
    
    func FetchCurriculum(_ curriculum : Curriculum){
        if let originalCurriculum = store.curriculums[curriculum.name] {
            curriculum.startingWeek = originalCurriculum.startingWeek
            curriculum.endingWeek = originalCurriculum.endingWeek
            curriculum.lectures = originalCurriculum.lectures
            curriculum.theme = originalCurriculum.theme
        }
    }
    
    func ShowCurriculumDetail(name : String){
        newCurriculum.name = name
        FetchCurriculum(newCurriculum)
        deleting = true
        addingCurriculum = true
    }
    
    func clean_curriculum_notification(curriculum : Curriculum){
        let prefix = curriculum.name
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToDelete = requests.filter { $0.identifier.hasPrefix(prefix) }.map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToDelete)
        }
    }
    
    func change_curriculum_notification(curriculum : Curriculum){
        let content = UNMutableNotificationContent()
        content.title = "\(curriculum.name)"
        content.body = "is about to begin in \(store.preferences.headsup_min) minutes."
        let calendar = Calendar.current;
        
        for lecture in curriculum.lectures {
            for i in 0...curriculum.endingWeek - curriculum.startingWeek {
                let daysToAdd = lecture.day;
                //adding to start date to get correct date
                if let newDate = calendar.date(byAdding: .day, value: (i*7)+daysToAdd, to: preferences.startingDate){
                    // Extract date components
                    var day_components = calendar.dateComponents([.year, .month, .day, .weekday], from: newDate)
                    let hm_components = calendar.dateComponents([.hour, .minute], from: timeTable[lecture.from-1].start)
                    day_components.hour = hm_components.hour
                    day_components.minute = hm_components.minute
                    
                    let date = calendar.date(from: day_components) ?? newDate
                    let minutesAgo = calendar.date(byAdding: .minute, value: -store.preferences.headsup_min, to: date) ?? date
                    let components = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: minutesAgo)
                    
                    // Create the trigger as a non-repeating event.
                    let trigger = UNCalendarNotificationTrigger(
                        dateMatching: components, repeats: false)
                    
                    // Create the request
                    let uuidString = curriculum.name + UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString,
                                                        content: content, trigger: trigger)
                    
                    // Schedule the request with the system.
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request) { (error) in
                        if error != nil {
                            // Handle any errors.
                        }
                    }
                }
                else {
                    // Error handling
                }
            }
        }

    }
    
    var body: some View {
        VStack {
            ScheduleHeaderView(editing: $editingSchedule, editAction: {
                preferences = store.preferences
                timeTable = store.timeTable
            }, adding: $addingCurriculum, addAction: {
                deleting = false
                newCurriculum = Curriculum.newCurriculum()
                FetchCurriculum(newCurriculum)
            })
            
            TabView {
                ForEach(1...store.preferences.weeks, id: \.self){ i in
                    ScheduleGridView(onTap: ShowCurriculumDetail, editing: $editingSchedule, enableWeekends: store.preferences.enableWeekEnds, week: i)
                        .environmentObject(store)
                }
            }
            .tabViewStyle(.page)
        }
        .sheet(isPresented: $editingSchedule){
            NavigationStack{
                ScheduleDetailFormView(preferences: $preferences, timeTable: $timeTable, stringNumWeeks: String(store.preferences.weeks))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel") {
                                preferences = store.preferences
                                timeTable = store.timeTable
                                editingSchedule = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Done"){
                                store.preferences = preferences
                                store.timeTable = timeTable
                                editingSchedule = false
                                
                                for (_, c) in store.curriculums{
                                    clean_curriculum_notification(curriculum: c)
                                    change_curriculum_notification(curriculum: c)
                                }
                                
                                saveAction()
                            }
                        }
                    }
                    .environmentObject(store)
            }
        }
        .sheet(isPresented: $addingCurriculum) {
            NavigationStack {
                AddingCurriculumView(preferences: store.preferences, delete: deleting, saveAction: saveAction, showingSheet: $addingCurriculum, newCurriculum: $newCurriculum, curriculumName: newCurriculum.name, startingWeek: newCurriculum.startingWeek, endingWeek: newCurriculum.endingWeek, lectures: newCurriculum.lectures, theme: newCurriculum.theme)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel") {
                                addingCurriculum = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Done"){
                                addingCurriculum = false
                                var occupied : [Bool] = Array(repeating: false, count: store.timeTable.count)
                                for i in 0...newCurriculum.lectures.count-1{
                                    for j in newCurriculum.lectures[i].from-1...newCurriculum.lectures[i].to-1{
                                        if occupied[j] {
                                            newCurriculum.lectures.remove(at: i)
                                            break
                                        }
                                        else { occupied[j] = true }
                                    }
                                }
                                store.curriculums[newCurriculum.name] = newCurriculum
                                clean_curriculum_notification(curriculum: newCurriculum)
                                change_curriculum_notification(curriculum: newCurriculum)
                                saveAction()
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView(){}
        .environmentObject(ScheduleStore())
}
