//
//  ContentView.swift
//  WeatherApi
//
//  Created by Maxim Dmitrochenko on 10-11-2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var weatherForecastData: WeatherForecast? = nil
    @State public var selection = "Москва"
    
    let weatherSymbols: [String: String] = [
        "ясно": "sun.max",
        "небольшая облачность": "cloud.sun.fill",
        "небольшой снегопад": "cloud.snow.fill",
        "переменная облачность": "cloud.fill",
        "облачно с прояснениями": "cloud.fill",
        "пасмурно": "cloud.fill",
        "дождь": "cloud.rain",
        "небольшой дождь": "cloud.drizzle",
        "гроза": "cloud.bolt.rain",
        "снег": "snow",
        "туман": "cloud.fog",
        "дымка": "cloud.fog",
        "дым": "cloud.fog",
        "песчаная буря": "cloud.fog",
        "песок": "cloud.fog",
        "пепел": "cloud.fog",
        "пыль": "cloud.fog",
        "сильный ветер": "wind",
        "шквал": "cloud.bolt.rain"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .lightBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ExtractedView(selection: $selection, fetchData: fetchData)
                
                
                VStack {
                    Text(weatherForecastData == nil ? "-----" : weatherForecastData!.name)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    
                    Text(weatherForecastData == nil ? "-----" : "\(weatherForecastData!.coord.lon), \(weatherForecastData!.coord.lat)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.lightBlue)
                }
                
                VStack {
                    Image(systemName: (weatherForecastData == nil ? "wifi.slash" : weatherSymbols[weatherForecastData!.weather.first!.description] ?? "questionmark"))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 120)
                    
                    Text(weatherForecastData == nil ? "-----" : "\(weatherForecastData!.weather.first!.description.prefix(1).uppercased() + weatherForecastData!.weather.first!.description.dropFirst())")
                        .font(.title)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                }
                
                HStack {
                    InfoCard(
                        title: "Cur",
                        imageName: weatherForecastData == nil ? "wifi.slash" : weatherSymbols[weatherForecastData!.weather.first!.description] ?? "questionmark",
                        imageColor: .white,
                        value: weatherForecastData == nil ? "---" : "\(Int(weatherForecastData!.main.temp))°"
                    )
                    InfoCard(
                        title: "Like",
                        imageName: "thermometer.variable.and.figure",
                        imageColor: .white,
                        value: weatherForecastData == nil ? "---" : "\(Int(weatherForecastData!.main.feels_like))°"
                    )
                    InfoCard(
                        title: "Max",
                        imageName: "arrow.up.right",
                        imageColor: .green,
                        value: weatherForecastData == nil ? "---" : "\(Int(weatherForecastData!.main.temp_max))°"
                    )
                    InfoCard(
                        title: "Min",
                        imageName: "arrow.down.right",
                        imageColor: .red,
                        value: weatherForecastData == nil ? "---" : "\(Int(weatherForecastData!.main.temp_min))°"
                    )
                }
                .padding()
                
                Spacer()
            }
        }
        .onAppear(perform: fetchData)
    }
    
    public func fetchData() {
        let cityMap: [String: String] = [
            "Омск": "Omsk",
            "СПБ": "Saint Petersburg",
            "Новосиб": "Novosibirsk",
            "ЕКБ": "Yekaterinburg",
            "Москва": "Moscow"
        ]

        let cityName = cityMap[selection] ?? "Moscow"
        
        let url = ApiHelper.shared.buildUrlString(
            with: ApiSettings(city: cityName)
        )
        
        ApiHelper.shared.fetchData(with: url) { result in
            switch result {
            case .success(let weather):
                self.weatherForecastData = weather
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}


struct InfoCard: View {
    
    let title: String
    let imageName: String
    let imageColor: Color
    let value: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title2)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(imageColor)
            
            Text(value)
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
        }
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .opacity(0.2)
        }
    }
}

struct ExtractedView: View {
    @Binding var selection: String
    
    public let cities = ["Москва", "Омск", "СПБ", "Новосиб", "ЕКБ"]
    
    var fetchData: () -> Void
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(cities, id: \.self) { city in
                    Text(city)
                        .foregroundColor(city == selection ? .white : .white)
                        .tag(city)
                }
            }
            .preferredColorScheme(.dark)
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selection) {
                fetchData()
            }
        }
        .padding()
    }
}
