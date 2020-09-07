//
//  ResultTableSection.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

struct ResultTableSection {
    let header: String
    let rows: [Row]
    var color: UIColor? = nil
    
    struct Row {
        let label: String
        let value: String
        var style: UITableViewCell.CellStyle = .value2
    }
}
