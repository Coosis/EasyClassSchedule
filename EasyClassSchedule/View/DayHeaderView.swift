//
//  DayHeaderView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct DayHeaderView: View {
    let dateString : String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color.black)
            VStack{
                Text(dateString)
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    DayHeaderView(dateString: "12.12")
}
