//
//  ApiHelper.swift
//  WeatherApi
//
//  Created by Maxim Dmitrochenko on 10-11-2024.
//

import Foundation

class ApiHelper {
    public static let shared = ApiHelper()
    
    private init() {}
    
    public func buildUrlString(with apiSettings: ApiSettings) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(apiSettings.city)&appid=\(apiSettings.apiKey)&units=\(apiSettings.units)&lang=\(apiSettings.lang)"
    }
    
    public func fetchData(with url: String, completion: @escaping (Result<WeatherForecast, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noDataResponse))
                return
            }
            
            do {
                let weatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                completion(.success(weatherForecast))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
}

struct ApiSettings {
    let city: String
    let units = "metric"
    let apiKey = "9e78a97416f34cf0b2557673f5ce97e8"
    let lang = "ru"
}

enum ApiError: Error {
    case invalidUrl
    case noDataResponse
}
