//
//  ScheduleDetailFormView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/16.
//

import SwiftUI

struct ScheduleDetailFormView: View {
    @EnvironmentObject var store : ScheduleStore
    @Binding var preferences : Preferences
    @Binding var timeTable : [SectionTime]
    @State var stringNumWeeks : String
    @State private var selectedDate = Date()
    @State private var startOfWeek: Date?
    
    func getStartOfWeek(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
    }
    
    var body: some View {
        Form {
            Section("Starting Date") {
                DatePicker("Starting from", selection: $selectedDate, displayedComponents: .date)
                    .onChange(of: selectedDate){ oldValue, newValue in
                        startOfWeek = getStartOfWeek(from: newValue)
                        preferences.startingDate = startOfWeek ?? Date()
                    }
            }
            Section("Number of Weeks") {
                TextField("Number of weeks", text: $stringNumWeeks)
                .onSubmit {
                    if let numweeks = Int(stringNumWeeks) {
                        preferences.weeks = numweeks
                    }
                    stringNumWeeks = String(preferences.weeks)
                }
                .keyboardType(.numberPad)
            }
            Section("Section Theme"){
                Picker("Theme Color", selection: $preferences.theme) {
                    ForEach(Theme.allCases, id: \.id) { t in
                        Text(t.name)
                            .padding(4)
//                            .frame(maxWidth: .infinity)
                            .foregroundColor(t.accentColor)
                            .background(t.mainColor)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .tag(t)
                    }
                }
                .pickerStyle(.navigationLink)
            }
            Section("Minutes Before Alert"){
                Picker("Minutes", selection: $preferences.headsup_min) {
                    ForEach(0...60, id: \.self) { t in
                        Text("\(t)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 80)
            }
            Section("Sections"){
                if timeTable.count > 0 {
                    ForEach(0...timeTable.count-1, id: \.self) { i in
                        SectionTimeEditView(section: $timeTable[i])
                            .swipeActions {
                                Button(role: .destructive) {
                                    timeTable.remove(at: i)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                Button{
                    timeTable.append(SectionTime.newSection())
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
    ScheduleDetailFormView(preferences: .constant(Preferences()), timeTable: .constant(SectionTime.samples()), stringNumWeeks: "20")
        .environmentObject(ScheduleStore())
}
