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
    @State var newCurriculum : Curriculum = Curriculum.newCurriculum()
    let saveAction: ()->Void
    
    var body: some View {
        VStack {
            ScheduleHeaderView(editing: $editingSchedule, editAction: {
                preferences = store.preferences
                timeTable = store.timeTable
            }, adding: $addingCurriculum, addAction: {
                newCurriculum = Curriculum.newCurriculum()
            })
            
            TabView {
                ForEach(1...store.preferences.weeks, id: \.self){ i in
                    ScheduleGridView(enableWeekends: store.preferences.enableWeekEnds, week: i)
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
                                saveAction()
                            }
                        }
                    }
                    .environmentObject(store)
            }
        }
        .sheet(isPresented: $addingCurriculum) {
            NavigationStack {
                AddingCurriculumView(preferences: store.preferences, newCurriculum: $newCurriculum, curriculumName: "New Curriculum", startingWeek: 1, endingWeek: 1, lectures: [Lecture.newLecture()], theme: .ccyan)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel") {
                                addingCurriculum = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Done"){
                                addingCurriculum = false
                                store.curriculums[newCurriculum.name] = (newCurriculum)
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
