//
//  BaseResponse.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import Foundation

struct BaseResponse : Codable {
    let status : String?
    let message : String?
    let data : ResponseData?
}

struct ResponseData : Codable {
    let diets : Diets?
}
