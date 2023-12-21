//
//  DayEventView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/15.
//

import SwiftUI

struct DayEventView: View {
    @EnvironmentObject var store : ScheduleStore
    let onTap : (String)-> Void
    var heightPerEvent : Double {
        store.preferences.height
    }
    var spacing : Double {
        store.preferences.spacing
    }
    let dayStructure : DayEventStructure
    
    var body: some View {
        VStack(spacing: spacing){
            //actual block height: (number of section) * heightPerEvent + (number of section-1) * Spacing
            ForEach(dayStructure.events){ event in
                let num_section : Int = 1 + event.to - event.from
                let fnum_section : Double = Double(num_section)
                let block_occupied_height : Double = fnum_section * heightPerEvent
                let spacing_occupied_height : Double = spacing * (fnum_section-1)
                let height : Double = block_occupied_height + spacing_occupied_height
                let color : Theme = event.theme
                EventRectangle(onTap: onTap, height: height, theme: color, eventName: event.EventName, eventTime: event.EventTimeString(timeTable: store.timeTable), visible: !event.filler)
            }
        }
    }
}

#Preview {
    DayEventView(onTap : { name in }, dayStructure: DayEventStructureSamples)
        .environmentObject(ScheduleStore())
}
