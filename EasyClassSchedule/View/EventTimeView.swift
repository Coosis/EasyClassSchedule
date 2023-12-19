//
//  EventTimeView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct EventTimeView: View {
    let time : String
    let color : Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(color)
            Text("\(time)")
                .font(.custom("", size: CGFloat(10)))
        }
    }
}

#Preview {
    EventTimeView(time: "10:00-13:00", color: .cyan)
}
