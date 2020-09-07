//
//  PickerDataModel.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

struct PickerDataModel {
    let key: Int
    let value: String
}

enum SelectWeatherPickerType {
    case wind, temperature, precipation
}
