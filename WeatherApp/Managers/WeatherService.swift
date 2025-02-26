//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 20.02.2025.
//

import Foundation

class WeatherService {
    private let apiKey = "hGVnudDlbKgdqK9VM9unoPaINqHaG58w"
    
    private func fetchCityData(urlString: String, completion: @escaping (City?, WeatherServiceError?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, .networkError(error.localizedDescription))
                return
            }
            
            guard let data = data else {
                completion(nil, .networkError("No data received."))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // For `getLocationKey`, decode directly to a single City
                if let city = try? decoder.decode(City.self, from: data) {
                    completion(city, nil)
                } else {
                    // For `getCityByName`, decode to an array of cities
                    let cities = try decoder.decode([City].self, from: data)
                    completion(cities.first, nil)
                }
                
            } catch {
                completion(nil, .decodingError("Failed to decode city data."))
            }
        }.resume()
    }
    
    private func fetchWeatherData(urlString: String, completion: @escaping (Weather?, WeatherServiceError?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, .networkError(error.localizedDescription))
                return
            }
            
            guard let data = data else {
                completion(nil, .networkError("No data received."))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherArray = try decoder.decode([Weather].self, from: data)
                if let firstWeather = weatherArray.first {  // Get the first item from the array
                    completion(firstWeather, nil)
                } else {
                    completion(nil, .decodingError("Empty weather data array."))
                }
            } catch {
                completion(nil, .decodingError("Failed to decode weather data."))
            }
        }.resume()
    }
    
    func getLocationKey(latitude: Double, longitude: Double, completion: @escaping (City?, WeatherServiceError?) -> Void) {
        let urlString = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(apiKey)&q=\(latitude),\(longitude)"
        
        fetchCityData(urlString: urlString, completion: completion)
    }
    
    func getWeather(locationKey: String, completion: @escaping (Weather?, WeatherServiceError?) -> Void) {
        let urlString = "http://dataservice.accuweather.com/currentconditions/v1/\(locationKey)?apikey=\(apiKey)"
        
        fetchWeatherData(urlString: urlString, completion: completion)
    }
    
    func getCityByName(cityName: String, completion: @escaping (City?, WeatherServiceError?) -> Void) {
        let urlString = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(apiKey)&q=\(cityName)"
        
        fetchCityData(urlString: urlString) { city, error in
            if let city = city, city.name.lowercased() == cityName.lowercased() {
                completion(city, nil)
            } else {
                completion(nil, .networkError("No exact match found for city name"))
            }
        }
    }
}
