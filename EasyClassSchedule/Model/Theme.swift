//
//  Theme.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/17.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable{
    case cblue
    case cred
    case cwhite
    case cgreen
    case corange
    case ccyan
    case cpurple
    
    var accentColor: Color {
        switch self {
        case .ccyan, .corange, .cwhite: return .black
        case .cpurple, .cred, .cgreen, .cblue: return .white
        }
    }
    
    var mainColor: Color {
        Color(rawValue)
    }
    
    var name: String {
        let rawName = rawValue.capitalized
        let startIndex = rawName.index(after: rawName.startIndex)
        return String(rawValue.capitalized[startIndex..<rawName.endIndex])
    }
    
    var id: String{
        name
    }
}
