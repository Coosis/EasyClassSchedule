//
//  Lecture.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/17.
//

import Foundation

struct Lecture : Codable{
    var day : Int
    var from : Int
    var to : Int
    
    func getDayString() -> String {
        var res : String = ""
        if day == 1 {
            res = "Mon"
        }
        else if day == 2 {
            res = "Tue"
        }
        else if day == 3 {
            res = "Wen"
        }
        else if day == 4 {
            res = "Thu"
        }
        else if day == 5 {
            res = "Fri"
        }
        else if day == 6 {
            res = "Sat"
        }
        else if day == 7 {
            res = "Sun"
        }
        return res;
    }
    static func newLecture() -> Lecture {
        return Lecture(day: 1, from: 1, to: 1)
    }
}
