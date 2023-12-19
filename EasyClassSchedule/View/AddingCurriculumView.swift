//
//  AddingCurriculumView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/19.
//

import SwiftUI

struct AddingCurriculumView: View {
    var preferences : Preferences
    @Binding var newCurriculum : Curriculum
    @State var curriculumName : String
    @State var startingWeek : Int
    @State var endingWeek : Int
    @State var lectures : [Lecture]
    @State var theme : Theme
    var body: some View {
        Form {
            Section("Curriculum Name"){
                TextField("", text: $curriculumName)
                    .onSubmit {
                        newCurriculum.name = curriculumName
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
                        Picker("From", selection: $lectures[i].from) {
                            ForEach(1...preferences.days, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .onChange(of: lectures[i].from) {
                            newCurriculum.lectures = lectures
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 80)
                        Picker("To", selection: $lectures[i].to) {
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
                }
                Button{
                    lectures.append(Lecture.newLecture())
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Section")
                    }
                }
            }
        }
    }
}

#Preview {
    AddingCurriculumView(preferences: Preferences(), newCurriculum: .constant(Curriculum.newCurriculum()), curriculumName: "new curriculum", startingWeek: 1, endingWeek: 1, lectures: [Lecture.newLecture()], theme: Theme.cblue)
}
