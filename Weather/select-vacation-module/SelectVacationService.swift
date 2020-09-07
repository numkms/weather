//
//  SelectVacationService.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation


class SelectVacationService {
    enum DateType { case from, to }
    
    static let shared = SelectVacationService()
    
    private(set) var model = SelectVacationModel()
    
    func set(temperature: Int) {
        model.weather.temperature = temperature
    }
    
    func set(wind: Int) {
        model.weather.wind = wind
    }
    
    func set(precipitation: Int) {
        model.weather.precipitation = precipitation
    }
    
    func set(date: Date, for type: DateType) {
        switch type {
        case .from:
            model.fromDate = date
        case .to:
            model.toDate = date
        }
        
        if model.fromDate > model.toDate {
            if type == .from {
                model.toDate = model.fromDate
            } else {
                model.fromDate = model.toDate
            }
            
        }
    }
    
    func set(myWeather: SelectVacationModel.Weather) {
        model.myWeather = myWeather
    }
    
    func add(place: Place) {
        model.places.append(place)
    }
    
    func remove(place: Place) {
        model.places = model.places.compactMap { exPlace in
            return exPlace == place ? nil : exPlace
        }
    }
}
