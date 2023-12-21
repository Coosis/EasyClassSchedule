//
//  ScheduleHeaderView.swift
//  EasyClassSchedule
//
//  Created by Vladimir Brooks on 2023/12/16.
//

import SwiftUI

struct ScheduleHeaderView: View {
    @Binding var editing : Bool
    let editAction : ()->Void
    @Binding var adding : Bool
    let addAction : ()->Void
    var body: some View {
        HStack{
            Button{
                addAction()
                adding = true
            } label: {
                Text("Add")
            }
            .padding()
            Spacer()
            Text("Schedule")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            Spacer()
            Button{
                editAction()
                editing = true
            } label: {
                Text("Edit")
            }
            .padding()
        }
    }
}

#Preview {
    ScheduleHeaderView(editing: .constant(false), editAction: {}, adding: .constant(false), addAction: {})
}
