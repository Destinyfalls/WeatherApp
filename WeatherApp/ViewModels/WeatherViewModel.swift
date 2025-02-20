//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 20.02.2025.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var city: City?
    @Published var weather: Weather?
}
