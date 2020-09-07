//
//  SelectVacationInteractor.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import CoreLocation
class SelectVacationInteractor: PresenterToInteractorProtocol {
    
    let getLocation = GetLocation()
    
    func updateWeatherModelValue(precipation: Int) {
        SelectVacationService.shared.set(precipitation: precipation)
        self.buildTableByModel()
    }
    
    func updateWeatherModelValue(temperature: Int) {
        SelectVacationService.shared.set(temperature: temperature)
        self.buildTableByModel()
    }
    
    func updateWeatherModelValue(wind: Int) {
        SelectVacationService.shared.set(wind: wind)
        self.buildTableByModel()
    }
    
    var presenter: InteractorToPresenterProtocol?
    
    func loadMyWeather() {
        getLocation.run {
            if let location = $0 {
                ApiManager.weatherApi.locationWeather(by: location, completion: { result in
                    switch result {
                    case .success(let weatherData):
                        SelectVacationService.shared.set(myWeather: SelectVacationModel.Weather.init(
                            temperature: Int(weatherData.temperature.metric?.value ?? 0),
                            precipitation: Int(weatherData.precipitationSummary.first?.value.metric?.value ?? 0) ,
                            wind: Int(weatherData.wind.speed.metric?.value ?? 0),
                            windUnit: weatherData.wind.speed.metric?.unit ?? "",
                            temperatureUnit: weatherData.temperature.metric?.unit ?? "",
                            precipitationUnit: weatherData.precipitationSummary.first?.value.metric?.unit ?? ""
                        ))
                        self.buildTableByModel()
                    case .failure(let error):
                        switch error {
                        case .decodingError(let message), .requestError(let message):
                            self.presenter?.showError(by: message)
                        }
                    }
                })
            } else {
                self.presenter?.showError(by: "Get Location failed \(self.getLocation.didFailWithError.debugDescription)")
            }
        }
    }
    
    func buildTableByModel() {
        let model = SelectVacationService.shared.model
        var sections: [SelectVacationTableViewSection] = []
        
        if let temperature = model.myWeather.temperature, let wind = model.myWeather.wind, let precipitation = model.myWeather.precipitation  {
            sections.append(.init(header: "Погода за окном", items: [
                .keyValue(.init(label: "Температура", value: "\(temperature) \(model.myWeather.temperatureUnit)"), {}),
                .keyValue(.init(label: "Ветер", value: "\(wind) \(model.myWeather.windUnit)"), {}),
                .keyValue(.init(label: "Осадки", value: "\(precipitation) \(model.myWeather.precipitationUnit)"), {})
            ]))
        } else {
            sections.append(.init(header: "Погода за окном", items: [
                .value(.init(value: "Загружаем..."), {})
            ]))
        }
        
        //Выбор даты
        sections.append(.init(header: "Выберите даты отпуска", items: [
            .keyValue(.init(label: "Начало", value: model.fromDate.formatForDisplay()), { [weak self] in self?.presenter?.pushToSelectDate(type: .from)
            }),
            .keyValue(.init(label: "Конец", value: model.toDate.formatForDisplay()), { [weak self] in  self?.presenter?.pushToSelectDate(type: .to)
            })
        ]));
        
        if model.places.count > 0 {
            sections.append(.init(header: "Места отдыха", items: model.places.map { place in
                return .value(.init(value: "\(place.name), \(place.country)"), {})
            }))
        }
        
        if model.places.count > 0 {
            sections.append(.init(header: "Погодные условия", items: [
                .keyValue(.init(label: "Температура", value: model.weather.temperatureFormatted), { [weak self] in
                    self?.presenter?.selectTemperature();
                }),
                .keyValue(.init(label: "Осадки", value: model.weather.precipitationFormatted), { [weak self] in
                    self?.presenter?.selectPrecipitation();
                }),
                .keyValue(.init(label: "Ветер", value: model.weather.windFormatted ), { [weak self] in
                    self?.presenter?.selectWind();
                })
            ]))
        }
        
        presenter?.updateTable(sections: sections)
        presenter?.setResultButton(isHidden: model.places.count == 0)
    }
    
}
