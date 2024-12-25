//
//  Recipes.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import Foundation

struct Recipes : Codable, Identifiable {
    let id : Int?
    let title : String?
    let timeSlot : String?
    let duration : Int?
    let image : String?
    let isFavorite : Int?
    let isCompleted : Int?
}
