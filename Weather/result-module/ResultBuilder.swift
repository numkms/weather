//
//  ResultBuilder.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation


class ResultBuilder {
    enum ResultBuilderError: Error {
        case getDataErrors([String])
    }
    
    static func build(completionString: @escaping (Result<String, ResultBuilderError>) -> Void)  {
        var message = "Я нашел себе идеальное место для отдыха в приложении Weather!\nВот мой список:\n"
        
        ResultBuilder.build(completion: { result in
            switch result {
            case .success(let model):
                let cities: String = model.weathers.reduce("") { (acc, el) in
                   return acc + "\(el.place.name), \(el.place.country) \n"
                }
                message += cities
                completionString(.success(message))
            case .failure(let error):
                completionString(.failure(error))
            }
        })
        
    }
    
    static func build(completion: @escaping (Result<ResultModel, ResultBuilderError>) -> Void) {
        let vacationService = SelectVacationService.shared
        let model = vacationService.model
        let dispatchGroup = DispatchGroup()
        
        var weathers: [ResultModel.PlaceWeathers] = []
        var errorMessages: [String] = []
        model.places.forEach { place in
            dispatchGroup.enter()
            ApiManager.weatherApi.location5DaysForecast(by: place, completion: { forecastResult in
                switch forecastResult {
                case .success(let forecast):
                    weathers.append(.init(place: place, dateForecasts: forecast.dailyForecasts.map { dateForecast in
                        return .init(date: dateForecast.date, forecast: dateForecast)
                    }))
                case .failure(let error):
                    switch error {
                    case .decodingError(let message), .requestError(let message):
                        errorMessages.append(message)
                    }
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            if errorMessages.count > 0 {
                completion(.failure(.getDataErrors(errorMessages)))
            } else {
                completion(.success(ResultSorter.sort(result: ResultModel(weathers: weathers))))
            }
        });
    }
}
