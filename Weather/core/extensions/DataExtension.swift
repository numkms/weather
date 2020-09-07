//
//  DataExtension.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

extension Data {
    func decode<T: Codable>() -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try?decoder.decode(T.self, from: self)
    }
}


fileprivate extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
