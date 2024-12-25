//
//  EnumCollection.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import SwiftUI

enum DayStatus: String, CaseIterable {
    case completed = "COMPLETED", current = "CURRENT", upcoming = "UPCOMING"
    
    var bgColor: Color {
        switch self {
        case .completed:
            return Color.green
        case .current:
            return Color.red
        case .upcoming:
            return Color.white
        }
    }
    
    var icon: Image {
        switch self {
        case .completed:
            return Image(systemName: "checkmark")
        case .current:
            return Image(systemName: "xmark")
        case .upcoming:
            return Image(systemName: "circle.fill")
        }
    }
}
