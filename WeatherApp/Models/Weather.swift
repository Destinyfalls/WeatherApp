//
//  Weather.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 20.02.2025.
//

import Foundation

struct Weather: Decodable {
    let weatherText: String
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText"
        case temperature = "Temperature"
    }
}

struct Temperature: Decodable {
    let metric: Metric
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
    }
}

struct Metric: Decodable {
    let value: Double
    let unit: String
    let unitType: Int
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}
