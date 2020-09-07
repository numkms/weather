//
//  ResultPresenter.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

class ResultPresenter: ResultViewToPresenterProtocol {
    var view: ResultPresenterToViewProtocol?
    var interactor: ResultPresenterToInteractorProtocol?
    var router: ResultPresenterToRouterProtocol?
}

extension ResultPresenter: ResultInteractorToPresenterProtocol {
    func showError(by message: String) {
        view?.showError(by: message)
    }
    
    func shareResult(by message: String) {
        self.view?.shareResult(by: message)
    }
    
    func displayResult(by model: ResultModel) {
        var sections: [ResultTableSection] = []
        let selectVacationModel = SelectVacationService.shared.model
        sections.append(.init(header: "Погода за окном", rows: [
            .init(label: "Температура", value: "\(selectVacationModel.myWeather.temperature ?? 0) \(selectVacationModel.myWeather.temperatureUnit)"),
            .init(label: "Ветер", value: "\(selectVacationModel.myWeather.wind ?? 0) \(selectVacationModel.myWeather.windUnit)"),
            .init(label: "Осадки", value: "\(selectVacationModel.myWeather.precipitation ?? 0) \(selectVacationModel.myWeather.precipitationUnit)")
        ]));
        var i = 1;
        let forecastSections: [ResultTableSection] = model.weathers.map { weather in
            let place = weather.place
            let dateForecasts = weather.dateForecasts
            
            let header = "#\(i) \(place.name), \(place.country)"
            var rows: [ResultTableSection.Row] = []
            dateForecasts.forEach { dateForecast in
                let date = dateForecast.date
                let forecast = dateForecast.forecast
                
                rows.append(.init(
                    label: "Дата",
                    value: date.formatForDisplay(),
                    style: .value1
                ))
                rows.append(.init(
                    label: "Температура",
                    value: "\(forecast.temperature.minimum.value ?? 0) \(forecast.temperature.minimum.unit )"
                ))
                rows.append(.init(
                    label: "Ветер",
                    value: "\(forecast.day.wind.speed.value) \(forecast.day.wind.speed.unit)"
                ))
                var precipitationFormatted = "Отсутствуют"
                if let type = forecast.day.precipitationType {
                    precipitationFormatted = "\(type)"
                }
                
                if let intensity = forecast.day.precipitationIntensity {
                    precipitationFormatted += ", \(intensity)"
                }
                
                if let rain = forecast.day.rain {
                    precipitationFormatted += ", \(Int(rain.value!))\(rain.unit)"
                }
                
                rows.append(.init(
                    label: "Осадки",
                    value: precipitationFormatted
                ))
            }
            i = i+1;
            return .init(header: header, rows: rows)
        }
        
        sections.append(contentsOf: forecastSections)
        
        view?.displayResult(by: sections)
    }
}
