//
//  SelectVacationModel.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

class SelectVacationModel {
    var fromDate =  Date();
    var toDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    var places: [Place] = []
    var weather: Weather = Weather(temperature: nil, precipitation: nil, wind: nil)
    var myWeather: Weather = Weather(temperature: nil, precipitation: nil, wind: nil)
    
    struct Weather {
        var temperature: Int?
        var precipitation: Int?
        var wind: Int?
        
        var windUnit: String = ""
        var temperatureUnit: String = ""
        var precipitationUnit: String = ""
        
        var windFormatted: String {
            guard let wind = wind else {
                return "Не указано"
            }
            return "\(wind) м/с"
        }
        
        var precipitationFormatted: String {
            guard let precipitation = precipitation else {
                return "Не указано"
            }
            return "\(precipitation) мм"
        }
        
        var temperatureFormatted: String {
            guard let temperature = temperature else {
                return "Не указано"
            }
            return "\(temperature) C"
        }
    }
}


