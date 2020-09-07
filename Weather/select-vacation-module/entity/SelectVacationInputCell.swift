//
//  SelectVacationViewModel.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//
import Foundation
import UIKit

struct SelectVacationKeyValueCell {
    let label: String
    let value: String
}

struct SelectVacationValueCell {
    let value: String
}

struct SelectVacationTableViewSection {
    let header: String
    let items: [SelectVacationCell]
}

enum SelectVacationCell {
    case keyValue(SelectVacationKeyValueCell, () -> Void)
    case value(SelectVacationValueCell, () -> Void)
}
