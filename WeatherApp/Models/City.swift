//
//  City.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 20.02.2025.
//

import Foundation

struct City: Decodable {
    let name: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case name = "LocalizedName"
        case code = "Key"
    }
}
