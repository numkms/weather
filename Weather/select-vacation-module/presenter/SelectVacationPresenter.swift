//
//  SelectVacationPresenter.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

class SelectVacationPresenter: ViewToPresenterProtocol {
    
    
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    func buildTableByModel() {
        interactor?.buildTableByModel()
    }
    
    func updateWeatherModelValue(precipation: Int) {
        interactor?.updateWeatherModelValue(precipation: precipation)
    }
    
    func updateWeatherModelValue(temperature: Int) {
        interactor?.updateWeatherModelValue(temperature: temperature)
    }
    
    func updateWeatherModelValue(wind: Int) {
        interactor?.updateWeatherModelValue(wind: wind)
    }
    
}

extension SelectVacationPresenter: InteractorToPresenterProtocol {
    func showError(by message: String) {
        view?.showError(by: message)
    }
    
    
    func selectTemperature() {
        view?.selectTemperature(temperatures: (-50...50).map { temperature in
            return .init(key: temperature, value: "\(temperature) C")
        })
    }
    
    func selectPrecipitation() {
        view?.selectPrecipitation(precipitations: (0...20).map { precipitation in
            return .init(key: precipitation, value: "\(precipitation) мм")
        })
    }
    
    func selectWind() {
        view?.selectWind(windsVlaues: (0...40).map { windSpeed in
            return .init(key: windSpeed, value: "\(windSpeed) км/ч")
        })
    }
    
    func pushToSelectDate(type: SelectVacationService.DateType) {
        view?.pushToSelectDate(type: type)
    }
    
    //Вызовы
    func updateTable(sections: [SelectVacationTableViewSection]) {
        view?.updateTable(sections: sections)
    }
    
    func setResultButton(isHidden: Bool) {
        view?.setResultButton(isHidden: isHidden);
    }
}
