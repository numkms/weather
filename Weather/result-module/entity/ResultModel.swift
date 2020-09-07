//
//  ResultModel.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

struct ResultModel {
    var weathers: [PlaceWeathers] = []
    
    struct PlaceWeathers {
        var place: Place
        var dateForecasts: [DateForecasts]
        struct DateForecasts {
            var date: Date
            var forecast: WeatherApi.Responses.DailyForecast
        }
    }
}
