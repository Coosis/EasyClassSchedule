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
