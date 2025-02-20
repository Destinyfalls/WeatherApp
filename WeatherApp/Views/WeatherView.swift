//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 19.02.2025.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var vm: WeatherViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.white)
                Text(vm.city?.name ?? "-")
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Spacer()
            
            VStack {
                Image("rainLogo")
                
                Text("\(vm.weather?.temperature.metric.value ?? 0.0, specifier: "%.1f")°C")
                    .font(.custom("Inter", size: 30))
                    .foregroundColor(.white)
                
                Text("\(vm.weather?.weatherText ?? "-")")
                    .font(.custom("Inter", size: 20))
                    .foregroundColor(.white)
                
            }
            
            Spacer()
            
            .padding()
        }
        .background(
            Color(hex: "#0F47B0")
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    WeatherView(vm: WeatherViewModel())
}
