//
//  Curriculum.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/17.
//

import SwiftUI

class Curriculum : Codable{
    var name : String
    var startingWeek : Int
    var endingWeek : Int
    
    var lectures : [Lecture]
    var theme : Theme
    
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
