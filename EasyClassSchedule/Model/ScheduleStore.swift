//
//  ScheduleStore.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/16.
//

import SwiftUI

struct Preferences : Codable{
    //to add a new property: 1. declare it  2. in init(from decoder : Decoder), add wrapper for default value.  3. in init(), add initialize logic.
    let height : Double
    let spacing : Double
    var theme : Theme
    var headsup_min : Int
    
    var enableWeekEnds : Bool
    var days : Int {
        enableWeekEnds ? 7 : 5
    }
    
    var startingDate : Date
    var weeks : Int
    
    //called by JSONDecoder().decode(Curriculum.self, from: data)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try container.decodeIfPresent(Double.self, forKey: .height) ?? 50
        self.spacing = try container.decodeIfPresent(Double.self, forKey: .spacing) ?? 10
        self.theme = try container.decodeIfPresent(Theme.self, forKey: .theme) ?? .cpurple
        self.enableWeekEnds = try container.decodeIfPresent(Bool.self, forKey: .enableWeekEnds) ?? true
        self.startingDate = try container.decodeIfPresent(Date.self, forKey: .startingDate) ?? {
            let calendar = Calendar.current
            var date = Date()
            let componentsBefore = calendar.dateComponents([.year, .month, .day], from: date)
            date = calendar.date(from: componentsBefore) ?? date
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
            date = calendar.date(from: components) ?? date
            return date
        }()
        self.headsup_min = try container.decodeIfPresent(Int.self, forKey: .headsup_min) ?? 10
        self.weeks = try container.decodeIfPresent(Int.self, forKey: .weeks) ?? 20
    }
    
    init() {
        self.height = 50
        self.spacing = 10
        self.theme = .cpurple
        self.enableWeekEnds = true
        
        let calendar = Calendar.current
        var date = Date()
        let componentsBefore = calendar.dateComponents([.year, .month, .day], from: date)
//        componentsBefore.year = 2024
//        componentsBefore.month = 9
//        componentsBefore.day = 1
        date = calendar.date(from: componentsBefore) ?? date
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        date = calendar.date(from: components) ?? date
        self.startingDate = date
        
        self.headsup_min = 10
        self.weeks = 20
    }
}

@MainActor
class ScheduleStore : ObservableObject {
    @Published var curriculums : [String : Curriculum] = [:]
    @Published var timeTable : [SectionTime] = []
    @Published var preferences : Preferences
    
    init() {
        self.curriculums = [:]
        self.timeTable = SectionTime.samples()
        self.preferences = Preferences()
    }
    
    private static func curriculumsFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("curriculums.data")
    }
    
    private static func timeTableFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("timeTable.data")
    }
    
    private static func preferencesFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("preferences.data")
    }
    
    func load() async throws {
        //loading curriculums
        let load_curriculums_task = Task<[String:Curriculum], Error> {
            let fileURL = try Self.curriculumsFileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return [:]
            }
            let curriculums = try JSONDecoder().decode([String:Curriculum].self, from: data)
            return curriculums
        }
        let curriculums = try await load_curriculums_task.value
        self.curriculums = curriculums
        
        //loading preferences
        let load_preference_task = Task<Preferences, Error> {
            let fileURL = try Self.preferencesFileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return Preferences()
            }
            let preferences = try JSONDecoder().decode(Preferences.self, from: data)
            return preferences
        }
        let preferences = try await load_preference_task.value
        self.preferences = preferences
        
        //loading timeTable
        let load_timeTable_task = Task<[SectionTime], Error> {
            let fileURL = try Self.timeTableFileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return SectionTime.samples()
            }
            let timeTable = try JSONDecoder().decode([SectionTime].self, from: data)
            return timeTable
        }
        let timeTable = try await load_timeTable_task.value
        self.timeTable = timeTable
    }
    
    func save() async throws {
        let save_curriculum_task = Task {
            let data = try JSONEncoder().encode(self.curriculums)
            let outfile = try Self.curriculumsFileURL()
            try data.write(to: outfile)
        }
        _ = try await save_curriculum_task.value
        
        let save_preferences_task = Task {
            let data = try JSONEncoder().encode(self.preferences)
            let outfile = try Self.preferencesFileURL()
            try data.write(to: outfile)
        }
        _ = try await save_preferences_task.value
        
        let save_timeTable_task = Task {
            let data = try JSONEncoder().encode(self.timeTable)
            let outfile = try Self.timeTableFileURL()
            try data.write(to: outfile)
        }
        _ = try await save_timeTable_task.value
    }
}
