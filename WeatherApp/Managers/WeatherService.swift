//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 20.02.2025.
//

import Foundation

class WeatherService {
    private let apiKey = "gvDe98lOwsPDUGOUKnfTF2wJcIAyfjNe"
    
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
                  let city = try decoder.decode(City.self, from: data)
                  completion(city, nil)
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
  }
