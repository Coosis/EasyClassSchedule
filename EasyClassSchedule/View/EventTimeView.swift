//
//  EventTimeView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct EventTimeView: View {
    let time : String
    let theme : Theme
    let onTap : ()->Void
    var body: some View {
        Button{
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(theme.mainColor)
                Text("\(time)")
                    .foregroundStyle(theme.accentColor)
                    .font(.custom("", size: CGFloat(10)))
            }
        }
    }
}

#Preview {
    EventTimeView(time: "10:00-13:00", theme: .cblue, onTap: {})
}
