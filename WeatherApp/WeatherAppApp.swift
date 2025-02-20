//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 19.02.2025.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}
