//
//  Diets.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import Foundation

struct Diets : Codable {
    var dietStreak : [String]?
    var allDiets : [AllDiets]?
    
    init(
        dietStreak: [String]? = .none,
        allDiets: [AllDiets]? = .none
    ) {
        self.dietStreak = dietStreak
        self.allDiets = allDiets
    }
}
