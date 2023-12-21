//
//  AddingCurriculumView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/19.
//

import SwiftUI

struct AddingCurriculumView: View {
    @EnvironmentObject var store : ScheduleStore
    var preferences : Preferences
    var delete : Bool
    let saveAction: ()->Void
    func deleteAction(){
        if let _ = store.curriculums[curriculumName] {
            store.curriculums.removeValue(forKey: curriculumName)
        }
        showingSheet = false
        saveAction()
    }
    @Binding var showingSheet : Bool
    @Binding var newCurriculum : Curriculum
    @State var curriculumName : String
    @State var startingWeek : Int
    @State var endingWeek : Int
    @State var lectures : [Lecture]
    @State var theme : Theme
    
    func givenName(name : String) {
        if let curriculum = store.curriculums[curriculumName] {
            startingWeek = curriculum.startingWeek
            endingWeek = curriculum.endingWeek
            lectures = curriculum.lectures
            theme = curriculum.theme
        }
    }
    
    var body: some View {
        Form {
            Section("Curriculum Name"){
                TextField("", text: $curriculumName)
                    .onChange(of: curriculumName) { oldv, newv in
                        newCurriculum.name = curriculumName
                        
                        givenName(name: curriculumName)
                    }
            }
            Section("Curriculum Time"){
                Picker("From Week", selection: $startingWeek) {
                    ForEach(1...preferences.weeks, id: \.self) { i in
                        Text("\(i)").tag(i)
                    }
                }
                .onChange(of: startingWeek){
                    newCurriculum.startingWeek = startingWeek
                    endingWeek = max(endingWeek, startingWeek)
                }
                Picker("To Week", selection: $endingWeek) {
                    ForEach(startingWeek...preferences.weeks, id: \.self) { i in
                        Text("\(i)").tag(i)
                    }
                }
                .onChange(of: endingWeek) {
                    newCurriculum.endingWeek = endingWeek
                }
            }
            Section("Theme") {
                Picker("Theme Color", selection: $theme) {
                    ForEach(Theme.allCases, id: \.id) { t in
                        Text(t.name)
                            .padding(4)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(t.accentColor)
                            .background(t.mainColor)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .tag(t)
                    }
                }
                .pickerStyle(.navigationLink)
                .onChange(of: theme){
                    newCurriculum.theme = theme
                }
            }
            Section("Lectures"){
                ForEach(0...lectures.count-1, id: \.self) { i in
                    HStack{
                        Picker("On", selection: $lectures[i].day) {
                            Text("Mon").tag(1)
                            Text("Tue").tag(2)
                            Text("Wen").tag(3)
                            Text("Thu").tag(4)
                            Text("Fri").tag(5)
                            Text("Sat").tag(6)
                            Text("Sun").tag(7)
                        }
                        .onChange(of: lectures[i].day) {
                            newCurriculum.lectures = lectures
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 80)
                        Text("From")
                        Picker("", selection: $lectures[i].from) {
                            ForEach(1...preferences.days, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .onChange(of: lectures[i].from) {
                            newCurriculum.lectures = lectures
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 80)
                        Text("To")
                        Picker("", selection: $lectures[i].to) {
                            ForEach(lectures[i].from...preferences.days, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .onChange(of: lectures[i].to) {
                            newCurriculum.lectures = lectures
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 80)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            lectures.remove(at: i)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                Button{
                    lectures.append(Lecture.newLecture())
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Lecture")
                    }
                }
            }
            if delete {
                Section("Delete Curriculum"){
                    Button{
                        deleteAction()
                    } label: {
                        Text("Delete this curriculum")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    AddingCurriculumView(preferences: Preferences(), delete: false, saveAction: {}, showingSheet: .constant(true), newCurriculum: .constant(Curriculum.newCurriculum()), curriculumName: "curriculum name", startingWeek: 1, endingWeek: 1, lectures: [Lecture.newLecture()], theme: Theme.cblue)
        .environmentObject(ScheduleStore())
}
