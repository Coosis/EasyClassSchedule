//
//  EventRectangle.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct EventRectangle: View {
    let height : Double
    let color : Color
    let eventName : String
    let eventTime : String
    let visible : Bool
    var body: some View {
        ZStack {
            if visible {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(color)
                EventDetailView(eventName: eventName, eventTime: eventTime)
            }
            else {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(Color(red: 0, green: 0, blue: 0, opacity: 0))
            }
        }
        .frame(height: CGFloat(height))
    }
}

#Preview {
    EventRectangle(height: 50, color: Color.purple, eventName: "Advanced Math", eventTime: "10:00 - 24:00", visible: true)
}
