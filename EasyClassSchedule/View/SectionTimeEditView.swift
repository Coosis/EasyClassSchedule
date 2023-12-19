//
//  SectionTimeEditView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/16.
//

import SwiftUI

struct SectionTimeEditView: View {
    @Binding var section : SectionTime
    var body: some View {
        HStack {
            Spacer()
            DatePicker("From", selection: $section.start, displayedComponents: .hourAndMinute)
                .datePickerStyle(.graphical)
            Spacer()
            DatePicker("To", selection: $section.end, displayedComponents: .hourAndMinute)
                .datePickerStyle(.graphical)
        }
    }
}

#Preview {
    SectionTimeEditView(section : .constant(SectionTime.samples()[0]))
}
