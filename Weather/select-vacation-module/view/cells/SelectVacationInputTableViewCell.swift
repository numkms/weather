//
//  SelectVacationInputTableViewCell.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import UIKit

class SelectVacationInputTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SelectVacationInputTableViewCell"
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .init(x: 0, y: 0, width: 100, height: 21))
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        self.addSubview(label)
        
        self.addConstraint(.init(
            item: label,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 20
            ))
        
        self.addConstraint(.init(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0
            ))
        
        
        return label;
    }()
    
    lazy var value: UILabel = {
        let label = UILabel(frame: .init(x:0, y:0, width: 100, height: 21));
        label.text = "Не указано"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        
        self.addConstraint(.init(
            item: label,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -40
            ))
        
        self.addConstraint(.init(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0
            ))
        
        return label
    }()
    
    func setInput(by inputCell: SelectVacationKeyValueCell) {
        self.accessoryType = .disclosureIndicator
        label.text = inputCell.label
        value.text = inputCell.value
    }
}
