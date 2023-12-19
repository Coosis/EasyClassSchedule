//
//  EventDetailView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct EventDetailView: View {
    let eventName : String
    let eventTime : String
    
    var body: some View {
        VStack{
            Text("\(eventName)")
                .font(.custom("", size: CGFloat(14)))
                .multilineTextAlignment(.center)
            Text("\(eventTime)")
                .font(.custom("", size: CGFloat(10)))
        }
    }
}

#Preview {
    EventDetailView(eventName: "Advanced Math", eventTime: "10:00-15:20")
}
