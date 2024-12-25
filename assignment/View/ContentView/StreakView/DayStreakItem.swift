//
//  DayStreakItem.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import SwiftUI

struct DayStreakItem: View {
    var title: String
    var status: DayStatus
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: status == DayStatus.upcoming ? 2 : 0)
                    .fill(status.bgColor)
                    .frame(width: 36, height: 36)
                
                status.icon
                    .foregroundColor(status == DayStatus.upcoming ? .gray : .white)
                    .font(.body)
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
        }
    }
}

//#Preview {
//    DayStreakItem(title: "Morning", status: .upcoming)
//}
