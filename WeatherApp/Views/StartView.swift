//
//  StartView.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 19.02.2025.
//

import SwiftUI
import CoreLocation

struct StartView: View {
    
    @FocusState private var isSearching: Bool
    @State private var searchText: String = ""
    @StateObject private var locationManager = LocationManager()
    @State private var navigateToWeatherView = false
    private let weatherService = WeatherService()
    @State private var isLoading = false
    @StateObject var vm = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        Image("W")
                        
                        VStack(alignment: .leading) {
                            Text("weather")
                                .font(.custom("Inter", size: 30))
                                .foregroundColor(Color(hex: "#000000"))
                            Text("App")
                                .font(.custom("Inter", size: 30))
                                .foregroundColor(Color(hex: "#000000"))
                                .opacity(0.5)
                        }
                    }
                    
                    Spacer()
                    
                    Image("rainLogo")
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        HStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 47)
                                .overlay(
                                    Text("Get current location")
                                        .foregroundColor(.gray)
                                )
                            Button(action: {
                                if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                                    getUserWeatherData()
                                } else {
                                    ToastManager.shared.showToast(message: "We need your permission to show weather in your region")
                                    
                                }
                            }) {
                                Text("check")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 47)
                                    .background(Color(hex: "#08244F"))
                                    .cornerRadius(10)
                            }
                        }
                        
                        HStack {
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("", text: $searchText)
                                    .foregroundColor(.black)
                                    .focused($isSearching)
                            }
                            .padding()
                            .frame(height: 47)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(25)
                            
                            Button(action: {
                                if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                                    getSearchedCityWeatherData()
                                } else {
                                    ToastManager.shared.showToast(message: "Enter city name")
                                }
                            }) {
                                Text("check")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 47)
                                    .background(Color(hex: "#08244F"))
                                    .cornerRadius(10)
                            }
                            
                            
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .onTapGesture {
                    isSearching = false
                }
                .onAppear {
                    locationManager.checkAndRequestLocationPermission()
                }
                .navigationDestination(isPresented: $navigateToWeatherView) {
                    WeatherView(vm: vm)
                }
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.5)  // Background dim
                            .edgesIgnoringSafeArea(.all)  // Fill the entire screen
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(40)
                            .scaleEffect(3)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)  // Ensure it takes the whole space
                }
            }
        }
    }
    
    private func getUserWeatherData() {
        
        guard let location = locationManager.currentLocation else {
            ToastManager.shared.showToast(message: "Couldn't get user locations")
            return
        }
        
        isLoading = true
        let userLatitude = location.coordinate.latitude
        let userLongitude = location.coordinate.longitude
        
        weatherService.getLocationKey(latitude: userLatitude, longitude: userLongitude) { city, error in
            isLoading = false
            if let error = error {
                DispatchQueue.main.async {
                    ToastManager.shared.showToast(message: "Failed to get city data: \(error)")
                }
            } else if let city = city {
                vm.city = city
                getWeatherData(code: city.code)
            }
        }
    }
    
    private func getSearchedCityWeatherData() {
        isLoading = true
        weatherService.getCityByName(cityName: searchText) { city, error in
            isLoading = false
            if let error = error {
                DispatchQueue.main.async {
                    ToastManager.shared.showToast(message: "Failed to get city data: \(error)")
                }
            } else if let city = city {
                vm.city = city
                getWeatherData(code: city.code)
            }
        }
    }
    
    private func getWeatherData(code: String) {
        weatherService.getWeather(locationKey: code) { weather, error in
            if let error = error {
                DispatchQueue.main.async {
                    ToastManager.shared.showToast(message: "Failed to fetch weather data: \(error)")
                }
            } else if let weather = weather {
                vm.weather = weather
                navigateToWeatherView = true
            }
        }
    }
}

#Preview {
    StartView()
}
