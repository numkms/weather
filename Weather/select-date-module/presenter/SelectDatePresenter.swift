//
//  SelectDatePresenter.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

class SelectDatePresenter: SelectDateViewToPresenterProtocol {
    var view: SelectDatePresenterToViewProtocol?
    var interactor: SelectDatePresenterToInteractorProtocol?
    var router: SelectDatePresenterToRouterProtocol?    
}

extension SelectDatePresenter: SelectDateInteractorToPresenterProtocol {
    func setDate(date: Date) {
        self.view?.setDate(date: date)
    }
    
    func dateUpdated() {
        self.view?.dateUpdated()
    }
}
