//
//  City.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

struct Place : Codable, Hashable {
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let name: String
    let country: String
}
