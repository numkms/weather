//
//  ResultSorter.swift
//  Weather
//
//  Created by Владимир Курдюков on 07.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation


class ResultSorter {
    static func sort(result model: ResultModel) -> ResultModel {
        let vacationService = SelectVacationService.shared
        let vacationModel = vacationService.model
        
        let fromDate = Calendar.current.startOfDay(for: vacationModel.fromDate)
        let toDate =  Calendar.current.startOfDay(for: vacationModel.toDate) + 3600 * 24
        let dateRange = fromDate...toDate
        
        let weather = vacationModel.weather
        
        //Clear dates that we dont need
        return .init(weathers: model.weathers.compactMap { placeWeather in
            return ResultModel.PlaceWeathers(place: placeWeather.place, dateForecasts: placeWeather.dateForecasts.compactMap { dateForecast in
                if dateRange.contains(dateForecast.date) {
                    return .init(date: dateForecast.date, forecast: dateForecast.forecast )
                }
                return nil
            }.sorted { (first, second) in
                first.date < second.date
            })
        }.sorted {first, second in
            let temperatureAverageCalc: (ResultModel.PlaceWeathers) -> Int = { weathers in
                return weathers.dateForecasts.reduce(0, { acc, value in
                    guard let minValue = value.forecast.temperature.minimum.value, let maxValue = value.forecast.temperature.maximum.value else {
                       return 0
                    }
                    
                    return acc + (Int(minValue) + Int(maxValue)) / 2
                }) / weathers.dateForecasts.count
            }
            
            let precipitationAverageCalc: (ResultModel.PlaceWeathers) -> Int = { weathers in
                return weathers.dateForecasts.reduce(0, { acc, value in
                    guard let precipitation = value.forecast.day.rain?.value else {
                       return 0
                    }
                    return acc + Int(precipitation)
                }) / weathers.dateForecasts.count
            }
            
            let windAverageCalc: (ResultModel.PlaceWeathers) -> Int = { weathers in
                return weathers.dateForecasts.reduce(0, { acc, value in
                    return acc + Int(value.forecast.day.wind.speed.value)
                }) / weathers.dateForecasts.count
            }
            
            guard  let temperature = weather.temperature, let precipitation = weather.precipitation, let wind = weather.wind else  {
                return true
            }
            
            let scaleBase = 1000
            let scoreScale = (-scaleBase...scaleBase).map { return $0 }
            
            let getScore: (Int) -> Int = { value in
                return (scoreScale.firstIndex(of: value) ?? scaleBase)
            }
            
            let userTemperatureScalePosition = getScore(temperature)
            let userWindScalePosition = getScore(wind)
            let userPrecipitationScalePosition = getScore(precipitation)
            
            let firstTemperatureAverageScalePosition = getScore(temperatureAverageCalc(first))
            let secondTemperatureAverageScalePosition = getScore(temperatureAverageCalc(second))
            
            let firstWindAverageScalePosition = getScore(windAverageCalc(first))
            let secondWindAverageScalePosition = getScore(windAverageCalc(second))
            
            let firstPrecipitationAverageScalePosition = getScore(precipitationAverageCalc(first))
            let secondPrecipitationAverageScalePosition = getScore(precipitationAverageCalc(second))
            
        
            let firstTemperatureResult = abs(userTemperatureScalePosition - firstTemperatureAverageScalePosition)
            let secondTemperatureResult = abs(userTemperatureScalePosition - secondTemperatureAverageScalePosition)
            
            let firstPrecipitationResult = abs(userPrecipitationScalePosition - firstPrecipitationAverageScalePosition)
            let secondPrecipitationResult = abs(userPrecipitationScalePosition - secondPrecipitationAverageScalePosition)
            
            let firstWindResult = abs(userWindScalePosition - firstWindAverageScalePosition)
            let secondWindResult = abs(userWindScalePosition - secondWindAverageScalePosition)
            
            let firstResult = firstWindResult + firstPrecipitationResult + firstTemperatureResult
            let secondResult = secondWindResult + secondPrecipitationResult + secondTemperatureResult
            
            return firstResult < secondResult
        })
    }
}
