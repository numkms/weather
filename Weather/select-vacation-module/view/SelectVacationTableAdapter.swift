//
//  SelectVacationTableAdapter.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

class SelectVacationTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView
    var sections: [SelectVacationTableViewSection] = [];
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(SelectVacationInputTableViewCell.self, forCellReuseIdentifier: SelectVacationInputTableViewCell.reuseIdentifier)
    }
    
    func set(sections: [SelectVacationTableViewSection]) {
        self.sections = sections
        tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sections[indexPath.section].items[indexPath.row]
        switch cell {
        case .keyValue(let cellEntity,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectVacationInputTableViewCell.reuseIdentifier) as! SelectVacationInputTableViewCell
            cell.setInput(by: cellEntity)
            return cell;
        case .value(let cellEntity, _):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.detailTextLabel?.text = cellEntity.value
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = sections[indexPath.section].items[indexPath.row]
        switch cell {
        case .keyValue(_, let action):
            action()
        case .value(_, let action):
            action()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
