//
//  EventRectangle.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct EventRectangle: View {
    let onTap : (String)->Void
    let height : Double
    let theme : Theme
    let eventName : String
    let eventTime : String
    let visible : Bool
    var body: some View {
        ZStack {
            if visible {
                Button{
                    onTap(eventName)
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(theme.mainColor)
                        EventDetailView(eventName: eventName, eventTime: eventTime, theme: theme)
                    }
                }
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
    EventRectangle(onTap: { name in }, height: 50, theme: .cpurple, eventName: "Advanced Math", eventTime: "10:00 - 24:00", visible: true)
}
