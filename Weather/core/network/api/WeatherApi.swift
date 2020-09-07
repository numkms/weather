//
//  NominatimApi.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation


enum WeatherApiError: Error {
    case decodingError(String)
    case requestError(String)
}

class WeatherApi {
    
    let key = "";
    let request = Request(with: "https://dataservice.accuweather.com")
    
    func process<T: Codable>(result: Result<Data, Request.RequestError>) -> Result<T, WeatherApiError> {
        switch result {
        case .success(let data):
            if let decoded: T = data.decode() {
                return .success(decoded)
            } else {
                return .failure(.decodingError("Can't decode response"))
            }
        case .failure(let error):
            switch error {
            case .endpointError(let message):
                return .failure(.requestError(message))
            case .noData(let message):
                return .failure(.requestError(message))
            }
        }
    }
    
    func cityList(by query: String, completion: @escaping(Result<[Place], WeatherApiError>) -> Void) {
        request.get(url:"/locations/v1/cities/autocomplete?apikey=\(key)&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&language=ru-ru") { result in
            let decodeResult: Result<[Responses.AutoCompleteResponse], WeatherApiError> = self.process(result: result)
            switch decodeResult {
            case .success(let autocomplete):
                completion(.success(autocomplete.map { result in
                    return Place(
                        id: result.Key,
                        name: result.LocalizedName,
                        country: result.Country.LocalizedName
                    )
                }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func locationWeather(by locKey: String, completion: @escaping(Result<Responses.LocationWeatherElement, WeatherApiError>) -> Void) {
        request.get(url: "/currentconditions/v1/\(locKey)?apikey=\(key)&language=ru-ru&details=true") { result in
            let locationWeatherResult: Result<[Responses.LocationWeatherElement], WeatherApiError> = self.process(result: result)
            switch locationWeatherResult {
            case .success(let locationWeathers):
                if let locationWeather = locationWeathers.first {
                    completion(.success(locationWeather))
                    return
                }
                completion(.failure(.requestError("Empty result")))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func locationWeather(by location: CLLocation, completion: @escaping(Result<Responses.LocationWeatherElement, WeatherApiError>) -> Void) {
        request.get(url: "/locations/v1/cities/geoposition/search?apikey=\(key)&details=true&q=\(location.coordinate.latitude),\(location.coordinate.longitude)") { result in
            let autocompleteResult: Result<Responses.AutoCompleteResponse, WeatherApiError> = self.process(result: result)
            switch autocompleteResult {
            case .success(let autocomplete):
                self.locationWeather(by: autocomplete.Key, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func location5DaysForecast(by place: Place, completion: @escaping(Result<Responses.Forecast, WeatherApiError>) -> Void) {
        request.get(url: "/forecasts/v1/daily/5day/\(place.id)?apikey=\(key)&metric=true&details=true&language=ru-ru") { result in
            completion(self.process(result: result))
        }
    }
    
    struct Responses: Codable {
        struct AutoCompleteResponse: Codable {
            let Country: IDWithLocalizedName;
            let AdministrativeArea: IDWithLocalizedName;
            let LocalizedName: String
            let Key: String
            
            struct IDWithLocalizedName: Codable {
                let ID: String
                let LocalizedName: String
            }
        }
        
        struct LocationWeatherElement: Codable {
            let localObservationDateTime: String
            let epochTime: Int
            let weatherText: String
            let weatherIcon: Int
            let hasPrecipitation: Bool
            let precipitationType: JSONNull?
            let isDayTime: Bool
            let temperature, realFeelTemperature, realFeelTemperatureShade: ApparentTemperature
            let relativeHumidity, indoorRelativeHumidity: Int
            let dewPoint: ApparentTemperature
            let wind: Wind
            let windGust: WindGust
            let uvIndex: Int
            let uvIndexText: String
            let visibility: ApparentTemperature
            let obstructionsToVisibility: String
            let cloudCover: Int
            let ceiling, pressure: ApparentTemperature
            let pressureTendency: PressureTendency
            let past24HourTemperatureDeparture, apparentTemperature, windChillTemperature, wetBulbTemperature: ApparentTemperature
            let precip1Hr: ApparentTemperature
            let precipitationSummary: [String: ApparentTemperature]
            let temperatureSummary: TemperatureSummary
            let mobileLink, link: String

            enum CodingKeys: String, CodingKey {
                case localObservationDateTime = "LocalObservationDateTime"
                case epochTime = "EpochTime"
                case weatherText = "WeatherText"
                case weatherIcon = "WeatherIcon"
                case hasPrecipitation = "HasPrecipitation"
                case precipitationType = "PrecipitationType"
                case isDayTime = "IsDayTime"
                case temperature = "Temperature"
                case realFeelTemperature = "RealFeelTemperature"
                case realFeelTemperatureShade = "RealFeelTemperatureShade"
                case relativeHumidity = "RelativeHumidity"
                case indoorRelativeHumidity = "IndoorRelativeHumidity"
                case dewPoint = "DewPoint"
                case wind = "Wind"
                case windGust = "WindGust"
                case uvIndex = "UVIndex"
                case uvIndexText = "UVIndexText"
                case visibility = "Visibility"
                case obstructionsToVisibility = "ObstructionsToVisibility"
                case cloudCover = "CloudCover"
                case ceiling = "Ceiling"
                case pressure = "Pressure"
                case pressureTendency = "PressureTendency"
                case past24HourTemperatureDeparture = "Past24HourTemperatureDeparture"
                case apparentTemperature = "ApparentTemperature"
                case windChillTemperature = "WindChillTemperature"
                case wetBulbTemperature = "WetBulbTemperature"
                case precip1Hr = "Precip1hr"
                case precipitationSummary = "PrecipitationSummary"
                case temperatureSummary = "TemperatureSummary"
                case mobileLink = "MobileLink"
                case link = "Link"
            }
        }

        // MARK: - ApparentTemperature
        struct ApparentTemperature: Codable {
            let metric: Imperial?
            let imperial: Imperial?

            enum CodingKeys: String, CodingKey {
                case metric = "Metric"
                case imperial = "Imperial"
            }
        }

        // MARK: - Imperial
        struct Imperial: Codable {
            let value: Double
            let unit: String
            let unitType: Int

            enum CodingKeys: String, CodingKey {
                case value = "Value"
                case unit = "Unit"
                case unitType = "UnitType"
            }
        }

        // MARK: - PressureTendency
        struct PressureTendency: Codable {
            let localizedText, code: String

            enum CodingKeys: String, CodingKey {
                case localizedText = "LocalizedText"
                case code = "Code"
            }
        }

        // MARK: - TemperatureSummary
        struct TemperatureSummary: Codable {
            let past6HourRange, past12HourRange, past24HourRange: PastHourRange

            enum CodingKeys: String, CodingKey {
                case past6HourRange = "Past6HourRange"
                case past12HourRange = "Past12HourRange"
                case past24HourRange = "Past24HourRange"
            }
        }

        // MARK: - PastHourRange
        struct PastHourRange: Codable {
            let minimum, maximum: ApparentTemperature

            enum CodingKeys: String, CodingKey {
                case minimum = "Minimum"
                case maximum = "Maximum"
            }
        }

        // MARK: - Wind
        struct Wind: Codable {
            let direction: Direction
            let speed: ApparentTemperature

            enum CodingKeys: String, CodingKey {
                case direction = "Direction"
                case speed = "Speed"
            }
        }

        // MARK: - Direction
        struct Direction: Codable {
            let degrees: Int
            let localized, english: String

            enum CodingKeys: String, CodingKey {
                case degrees = "Degrees"
                case localized = "Localized"
                case english = "English"
            }
        }

        // MARK: - WindGust
        struct WindGust: Codable {
            let speed: ApparentTemperature

            enum CodingKeys: String, CodingKey {
                case speed = "Speed"
            }
        }

        typealias LocationWeather = [LocationWeatherElement]
        
        // MARK: - Forecast
        struct Forecast: Codable {
            let headline: Headline
            let dailyForecasts: [DailyForecast]

            enum CodingKeys: String, CodingKey {
                case headline = "Headline"
                case dailyForecasts = "DailyForecasts"
            }
        }

        // MARK: - DailyForecast
        struct DailyForecast: Codable {
            let date: Date
            let epochDate: Int
            let sun: Sun
            let moon: Moon
            let temperature, realFeelTemperature, realFeelTemperatureShade: RealFeelTemperature
            let hoursOfSun: Double
            let degreeDaySummary: DegreeDaySummary
//            let airAndPollen: [AirAndPollen]
            let day, night: Day
            let sources: [String]
            let mobileLink, link: String

            enum CodingKeys: String, CodingKey {
                case date = "Date"
                case epochDate = "EpochDate"
                case sun = "Sun"
                case moon = "Moon"
                case temperature = "Temperature"
                case realFeelTemperature = "RealFeelTemperature"
                case realFeelTemperatureShade = "RealFeelTemperatureShade"
                case hoursOfSun = "HoursOfSun"
                case degreeDaySummary = "DegreeDaySummary"
//                case airAndPollen = "AirAndPollen"
                case day = "Day"
                case night = "Night"
                case sources = "Sources"
                case mobileLink = "MobileLink"
                case link = "Link"
            }
        }

        // MARK: - AirAndPollen
        struct AirAndPollen: Codable {
            let name: String
            let value: Int
            let category: Category
            let categoryValue: Int
            let type: String?

            enum CodingKeys: String, CodingKey {
                case name = "Name"
                case value = "Value"
                case category = "Category"
                case categoryValue = "CategoryValue"
                case type = "Type"
            }
        }

        enum Category: String, Codable {
            case good = "Good"
            case low = "Low"
            case moderate = "Moderate"
        }

        // MARK: - Day
        struct Day: Codable {
            let icon: Int
            let iconPhrase: String
            let hasPrecipitation: Bool
            let shortPhrase, longPhrase: String
            let precipitationProbability, thunderstormProbability, rainProbability, snowProbability: Int
            let iceProbability: Int
            let wind, windGust: DayWind
            let rain, snow, ice: Ice?
            let hoursOfPrecipitation, hoursOfRain, hoursOfSnow, hoursOfIce: Double
            let cloudCover: Int
            let precipitationType, precipitationIntensity: String?
           
            enum CodingKeys: String, CodingKey {
                case icon = "Icon"
                case iconPhrase = "IconPhrase"
                case hasPrecipitation = "HasPrecipitation"
                case shortPhrase = "ShortPhrase"
                case longPhrase = "LongPhrase"
                case precipitationProbability = "PrecipitationProbability"
                case thunderstormProbability = "ThunderstormProbability"
                case rainProbability = "RainProbability"
                case snowProbability = "SnowProbability"
                case iceProbability = "IceProbability"
                case wind = "Wind"
                case windGust = "WindGust"
                case rain = "Rain"
                case snow = "Snow"
                case ice = "Ice"
                case hoursOfPrecipitation = "HoursOfPrecipitation"
                case hoursOfRain = "HoursOfRain"
                case hoursOfSnow = "HoursOfSnow"
                case hoursOfIce = "HoursOfIce"
                case cloudCover = "CloudCover"
                case precipitationType = "PrecipitationType"
                case precipitationIntensity = "PrecipitationIntensity"
            }
        }
        struct DayWind: Codable {
           let speed: Imperial
           let direction: Direction
           
           enum CodingKeys: String, CodingKey {
               case speed = "Speed"
               case direction = "Direction"
           }
       }
        // MARK: - Ice
        struct Ice: Codable {
            let value: Double?
            let unit: String
            let unitType: Int?

            enum CodingKeys: String, CodingKey {
                case value = "Value"
                case unit = "Unit"
                case unitType = "UnitType"
            }
        }

        enum Unit: String, Codable {
            case f = "F"
            case c = "C"
            case cm = "cm"
            case kmH = "km/h"
            case mm = "mm"
        }


        // MARK: - DegreeDaySummary
        struct DegreeDaySummary: Codable {
            let heating, cooling: Ice

            enum CodingKeys: String, CodingKey {
                case heating = "Heating"
                case cooling = "Cooling"
            }
        }

        // MARK: - Moon
        struct Moon: Codable {
            let rise: Date?
            let epochRise: Int?
            let moonSet: Date?
            let epochSet: Int?
            let phase: String
            let age: Int

            enum CodingKeys: String, CodingKey {
                case rise = "Rise"
                case epochRise = "EpochRise"
                case moonSet = "Set"
                case epochSet = "EpochSet"
                case phase = "Phase"
                case age = "Age"
            }
        }

        // MARK: - RealFeelTemperature
        struct RealFeelTemperature: Codable {
            let minimum, maximum: Ice

            enum CodingKeys: String, CodingKey {
                case minimum = "Minimum"
                case maximum = "Maximum"
            }
        }

        // MARK: - Sun
        struct Sun: Codable {
            let rise: Date
            let epochRise: Int
            let sunSet: Date
            let epochSet: Int

            enum CodingKeys: String, CodingKey {
                case rise = "Rise"
                case epochRise = "EpochRise"
                case sunSet = "Set"
                case epochSet = "EpochSet"
            }
        }

        // MARK: - Headline
        struct Headline: Codable {
            let effectiveDate: Date?
            let effectiveEpochDate, severity: Int
            let text, category: String
            let endDate: Date
            let endEpochDate: Int
            let mobileLink, link: String

            enum CodingKeys: String, CodingKey {
                case effectiveDate = "EffectiveDate"
                case effectiveEpochDate = "EffectiveEpochDate"
                case severity = "Severity"
                case text = "Text"
                case category = "Category"
                case endDate = "EndDate"
                case endEpochDate = "EndEpochDate"
                case mobileLink = "MobileLink"
                case link = "Link"
            }
        }


        // MARK: - Encode/decode helpers

        class JSONNull: Codable, Hashable {

            public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
                return true
            }

            public var hashValue: Int {
                return 0
            }
            
            

            public init() {}

            public required init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encodeNil()
            }
        }
    }
}
