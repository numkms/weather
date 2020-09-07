//
//  SelectDateVacationToInteractor.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
class SelectDateVacationToInteractor: SelectDatePresenterToInteractorProtocol {
    var presenter: SelectDateInteractorToPresenterProtocol?
    
    func update(date: Date) {
        SelectVacationService.shared.set(date: date, for: .to)
        presenter?.dateUpdated()
    }
    
    func setDate() {
        presenter?.setDate(date: SelectVacationService.shared.model.toDate);
    }
}
