//
//  DayEventStructure.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import Foundation

//General info of an event.
struct Event : Identifiable, Codable{
    let id : UUID
    let filler : Bool
    let EventName : String
    let from : Int
    let to : Int
    
    func EventTimeString(timeTable : [SectionTime]) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let start = formatter.string(from: timeTable[from-1].start)
        let end = formatter.string(from: timeTable[to-1].start)
        return "\(start)-\(end)"
    }
    
    init(filler : Bool, EventName : String, from : Int, to : Int){
        self.id = UUID()
        self.filler = filler
        self.EventName = EventName
        self.from = from
        self.to = to
    }
}

//The timing info of a section. When it starts, when it ends.
//[SectionTime] is the time table. Time table describes the time sections of a day.
struct SectionTime : Codable{
    var start : Date
    var end : Date
    
    var timeInMinutes : Int {
        return Int(end.timeIntervalSince1970 - start.timeIntervalSince1970) / 60
    }
    
    var timeString : String {
        let formatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        return "\(formatter.string(from: start))-\(formatter.string(from: start))"
    }
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    static func newSection() -> SectionTime {
        let newSec = SectionTime(start: Date(), end: Date())
        return newSec
    }
    
    static func samples() -> [SectionTime] {
        let calendar = Calendar.current
        let today = Date()
        let yearmonthday = calendar.dateComponents([.timeZone, .era, .year, .month, .day], from: today)
        let dc1 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 8, minute: 0)
        let dc2 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 8, minute: 45)
        let dc3 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 8, minute: 50)
        let dc4 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 9, minute: 35)
        let dc5 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 9, minute: 50)
        let dc6 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 10, minute: 35)
        let dc7 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 10, minute: 40)
        let dc8 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 11, minute: 25)
        let dc9 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 11, minute: 30)
        let dc10 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 12, minute: 15)
        let dc11 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 14, minute: 0)
        let dc12 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 14, minute: 45)
        let dc13 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 14, minute: 50)
        let dc14 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 15, minute: 35)
        let dc15 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 15, minute: 50)
        let dc16 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 16, minute: 35)
        let dc17 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 16, minute: 40)
        let dc18 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 17, minute: 25)
        let dc19 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 18, minute: 30)
        let dc20 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 19, minute: 15)
        let dc21 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 19, minute: 20)
        let dc22 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 20, minute: 5)
        let dc23 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 20, minute: 10)
        let dc24 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 20, minute: 55)
        let dc25 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 21, minute: 40)
        let dc26 = DateComponents(timeZone: yearmonthday.timeZone, era: yearmonthday.era, year: yearmonthday.year, month: yearmonthday.month, day: yearmonthday.day, hour: 22, minute: 25)
        
        let sec1 = SectionTime(start: calendar.date(from: dc1) ?? Date(), end: calendar.date(from: dc2) ?? Date())
        let sec2 = SectionTime(start: calendar.date(from: dc3) ?? Date(), end: calendar.date(from: dc4) ?? Date())
        let sec3 = SectionTime(start: calendar.date(from: dc5) ?? Date(), end: calendar.date(from: dc6) ?? Date())
        let sec4 = SectionTime(start: calendar.date(from: dc7) ?? Date(), end: calendar.date(from: dc8) ?? Date())
        let sec5 = SectionTime(start: calendar.date(from: dc9) ?? Date(), end: calendar.date(from: dc10) ?? Date())
        
        let sec6 = SectionTime(start: calendar.date(from: dc11) ?? Date(), end: calendar.date(from: dc12) ?? Date())
        let sec7 = SectionTime(start: calendar.date(from: dc13) ?? Date(), end: calendar.date(from: dc14) ?? Date())
        let sec8 = SectionTime(start: calendar.date(from: dc15) ?? Date(), end: calendar.date(from: dc16) ?? Date())
        let sec9 = SectionTime(start: calendar.date(from: dc17) ?? Date(), end: calendar.date(from: dc18) ?? Date())
        let sec10 = SectionTime(start: calendar.date(from: dc19) ?? Date(), end: calendar.date(from: dc20) ?? Date())
        
        let sec11 = SectionTime(start: calendar.date(from: dc21) ?? Date(), end: calendar.date(from: dc22) ?? Date())
        let sec12 = SectionTime(start: calendar.date(from: dc23) ?? Date(), end: calendar.date(from: dc24) ?? Date())
        let sec13 = SectionTime(start: calendar.date(from: dc25) ?? Date(), end: calendar.date(from: dc26) ?? Date())
        
        return [sec1, sec2, sec3, sec4, sec5, sec6, sec7, sec8, sec9, sec10, sec11, sec12, sec13]
    }
}

struct DayEventStructure : Identifiable, Codable{
    var id : UUID
    var events : [Event]
    
    init(timeTable: [SectionTime], events: [Event]) {
        self.id = UUID()
        
        //future optimization needed
        var covered_section = Array(repeating: false, count: timeTable.count)
        for event in events {
            for i in event.from...event.to {
                covered_section[i-1] = true
            }
        }
                
        
        var filledEvents : [Event] = []
        var i : Int = 1
        var j : Int = 1
        
        while i <= covered_section.count {
            if covered_section[i-1] {
                filledEvents.append(events[j-1])
                i += events[j-1].to-events[j-1].from
                j += 1
            }
            else {
                filledEvents.append(Event(filler: true, EventName: "Filler", from: i, to: i))
            }
            i += 1
        }
        
        self.events = filledEvents
    }
}

let DayEventStructureSamples : DayEventStructure = DayEventStructure(timeTable : SectionTime.samples(),
    events: [
        Event(filler: false, EventName: "高等数学", from: 1, to: 1),
        Event(filler: false, EventName: "大学英语", from: 3, to: 3),
        Event(filler: false, EventName: "程序设计", from: 4, to: 5)
])
