//
//  AllDiets.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import Foundation

struct AllDiets : Codable, Identifiable {
    var id: UUID? = UUID()
    let daytime : String?
    let timings : String?
    let progressStatus : ProgressStatus?
    let recipes : [Recipes]?
    
    init(
        daytime: String? = .none,
        timings: String? = .none,
        progressStatus: ProgressStatus? = .none,
        recipes: [Recipes]? = .none
    ) {
        self.daytime = daytime
        self.timings = timings
        self.progressStatus = progressStatus
        self.recipes = recipes
    }
}
