//
//  WeatherForecast.swift
//  WeatherApi
//
//  Created by Maxim Dmitrochenko on 10-11-2024.
//

import Foundation

struct WeatherForecast: Decodable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let description: String
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}
