//
//  Curriculum.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/17.
//

import SwiftUI

final class Curriculum : Codable{
    //to add a new property: 1. declare it  2. in init(from decoder : Decoder), add wrapper for default value. 3. in init(), add initialize logic.
    var name : String
    var startingWeek : Int
    var endingWeek : Int
    
    var lectures : [Lecture]
    var theme : Theme
    
    //called by JSONDecoder().decode(Curriculum.self, from: data)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Curriculum"
        self.startingWeek = try container.decodeIfPresent(Int.self, forKey: .startingWeek) ?? 1
        self.endingWeek = try container.decodeIfPresent(Int.self, forKey: .endingWeek) ?? 20
        self.lectures = try container.decodeIfPresent([Lecture].self, forKey: .lectures) ?? []
        self.theme = try container.decodeIfPresent(Theme.self, forKey: .theme) ?? Theme.cgreen
        
        //existingProperty = try container.decode(String.self, forKey: .existingProperty)
        //newProperty = try container.decodeIfPresent(Int.self, forKey: .newProperty) ?? 0 // Default value for new property
    }
    
    init(name : String, startingWeek: Int, endingWeek: Int, lectures : [Lecture], theme : Theme) {
        self.name = name
        self.startingWeek = startingWeek
        self.endingWeek = endingWeek
        self.lectures = lectures
        self.theme = theme
    }
    
    static func newCurriculum() -> Curriculum {
        let curriculum = Curriculum(name: "curriculum name", startingWeek: 1, endingWeek: 1, lectures: [Lecture.newLecture()], theme: .cblue)
        return curriculum
    }
}

let CurriculumSamples = [
    Curriculum(name: "大学英语", startingWeek: 8, endingWeek: 12, lectures: [
        Lecture(day: 4, from: 1, to: 2),
        Lecture(day: 5, from: 3, to: 4)
    ], theme: .cred),
    Curriculum(name: "高等数学", startingWeek: 4, endingWeek: 16, lectures: [
        Lecture(day: 1, from: 1, to: 2),
        Lecture(day: 3, from: 1, to: 2),
        Lecture(day: 5, from: 5, to: 5)
    ], theme: .cblue),
    Curriculum(name: "程序设计", startingWeek: 8, endingWeek: 12, lectures: [
        Lecture(day: 2, from: 1, to: 2),
        Lecture(day: 4, from: 3, to: 4)
    ], theme: .cgreen)
]
