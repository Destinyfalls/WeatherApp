//
//  Errors.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 20.02.2025.
//

import Foundation

enum WeatherServiceError: Error {
    case invalidURL
    case networkError(String)
    case decodingError(String)
}
