//
//  ContentView.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 19.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StartView()
            .overlay(
                VStack {
                    ToastView()
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            )
    }
    
}

#Preview {
    ContentView()
}
