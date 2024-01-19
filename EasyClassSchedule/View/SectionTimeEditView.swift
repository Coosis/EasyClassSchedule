//
//  SectionTimeEditView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/16.
//

import SwiftUI

struct SectionTimeEditView: View {
    @Binding var section : SectionTime
    
    func validify() {
        let calendar = Calendar.current;
        let startDateComponents = calendar.dateComponents([.hour, .minute], from: section.start)
        var endDateComponents = calendar.dateComponents([.hour, .minute], from: section.end)
        if(endDateComponents.hour ?? 0 < startDateComponents.hour ?? 0){
            endDateComponents.hour = startDateComponents.hour
            if(endDateComponents.minute ?? 0 < startDateComponents.minute ?? 0){
                endDateComponents.minute = startDateComponents.minute
            }
        }
        section.end = calendar.date(from: endDateComponents) ?? section.end
    }
    
    var body: some View {
        HStack {
            Spacer()
            DatePicker("From", selection: $section.start, displayedComponents: .hourAndMinute)
                .datePickerStyle(.graphical)
                .onChange(of: section.start){ old, new in
                    validify()
                }
            Spacer()
            DatePicker("To", selection: $section.end, displayedComponents: .hourAndMinute)
                .datePickerStyle(.graphical)
                .onChange(of: section.end){ old, new in
                    validify()
                }
        }
    }
}

#Preview {
    SectionTimeEditView(section : .constant(SectionTime.samples()[0]))
}
