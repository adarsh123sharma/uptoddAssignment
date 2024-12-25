//
//  Model+Extension.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

//MARK: Base Response
extension BaseResponse {
    var statusBoolean : Bool {
        return self.status?.lowercased() == "success"
    }
}

//extension Diets {
//     var statusEnum: [DayStatus] {
//        return dietStreak?.compactMap({ status in
//            return DayStatus(rawValue: status.lowercased())
//        }) ?? []
//    }
//}
