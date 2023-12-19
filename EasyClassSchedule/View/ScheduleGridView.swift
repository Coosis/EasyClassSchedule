//
//  ScheduleGridView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import Foundation
import SwiftUI

struct ScheduleGridView: View {
    @EnvironmentObject var store : ScheduleStore
    let weekdays : [String] = ["Mon", "Tue", "Wen", "Thu", "Fri"]
    let weekends : [String] = ["Sat", "Sun"]
    @State var enableWeekends : Bool
    @State var week : Int
//    @State var days : [DayEventStructure]
    var scheduledDays : [String] {
        enableWeekends ? weekdays + weekends : weekdays
    }
    var num_scheduledDays : Int {
        enableWeekends ? 7 : 5
    }
    
    var days: [DayEventStructure] {
        var computedDays: [DayEventStructure] = []
        var seq = [Calendar.current.firstWeekday-1]
        for i in 1...6 {
            seq.append(seq[i-1] + 1)
        }
        for i in 0...6 {
            if seq[i] > 7 {
                seq[i] -= 7
            }
            if seq[i] < 0 {
                seq[i] += 7
            }
        }
        
        for day in seq {
            var events : [Event] = []
            for (_, curriculum) in store.curriculums {
                if curriculum.startingWeek <= week && curriculum.endingWeek >= week {
                    for lecture in curriculum.lectures {
                        if lecture.day == day {
                            events.append(Event(filler: false, EventName: curriculum.name, from: lecture.from, to: lecture.to))
                        }
                    }
                }
            }
            computedDays.append(DayEventStructure(timeTable: store.timeTable, events: events))
        }
        return computedDays
    }
    
    init(enableWeekends : Bool, week : Int) {
        self.enableWeekends = enableWeekends
        self.week = week
    }
    
    func getDateString(numWeek : Int, numDays : Int) -> String {
        let calendar = Calendar.current
        let currentDate = calendar.date(byAdding: .day, value: (numWeek-1)*7 + (numDays-1), to: store.preferences.startingDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d E"
        return formatter.string(from: currentDate ?? Date())
    }
    
    var body: some View {
        ScrollView{
            Grid{
                GridRow{
                    Button{
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                            Text("\(week)")
                                .foregroundStyle(.black)
                        }
                    }
                    
                    
                    ForEach(1...num_scheduledDays, id:\.self) { i in
                        DayHeaderView(dateString: getDateString(numWeek: week, numDays: i))
                    }
                }
                GridRow{
                    VStack(spacing: store.preferences.spacing){
                        if store.timeTable.count > 0 {
                            ForEach(1...store.timeTable.count, id:\.self){ j in
                                EventTimeView(time: store.timeTable[j-1].timeString, color: .purple)
                            }
                        }
                    }
                    
                    ForEach(1...num_scheduledDays, id:\.self){ i in
                        if i-1 >= 0 && i-1 < days.count {
                            DayEventView(dayStructure: days[i-1])
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ScheduleGridView(enableWeekends: true, week: 19)
        .environmentObject(ScheduleStore())
}
