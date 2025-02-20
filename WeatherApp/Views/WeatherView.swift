//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 19.02.2025.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var vm = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text(vm.city?.name ?? "-")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Weather")
    }
}
#Preview {
    WeatherView()
}
