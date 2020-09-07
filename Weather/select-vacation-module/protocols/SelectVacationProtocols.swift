//
//  SelectVacationProtocols.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: class {
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    
    func buildTableByModel();
    
    func updateWeatherModelValue(precipation: Int)
    func updateWeatherModelValue(temperature: Int)
    func updateWeatherModelValue(wind: Int)
}

protocol PresenterToViewProtocol: class {
    func showError(by message: String)
    func updateTable(sections: [SelectVacationTableViewSection])
    func pushToSelectDate(type: SelectVacationService.DateType);
    func selectTemperature(temperatures: [PickerDataModel])
    func selectPrecipitation(precipitations: [PickerDataModel])
    func selectWind(windsVlaues: [PickerDataModel])
    func setResultButton(isHidden: Bool)
}

protocol PresenterToRouterProtocol: class {
    static func createModule()-> SelectVacationViewController
    func pushToSelectPlace(by navigationController: UINavigationController?)
    func modalSelectPlace(by uIViewController: UIViewController);
    func pushToSelectDate(by navigationController: UINavigationController?, type: SelectVacationService.DateType)
    func pushToResult(by navigationController: UINavigationController?)
}

protocol PresenterToInteractorProtocol: class {
    var presenter: InteractorToPresenterProtocol? {get set}
    
    func buildTableByModel()
    func loadMyWeather()
    func updateWeatherModelValue(precipation: Int)
    func updateWeatherModelValue(temperature: Int)
    func updateWeatherModelValue(wind: Int)
}

protocol InteractorToPresenterProtocol: class {
    func showError(by message: String)
    func updateTable(sections: [SelectVacationTableViewSection])
    func pushToSelectDate(type: SelectVacationService.DateType)
    func selectTemperature()
    func selectPrecipitation()
    func selectWind();
    func setResultButton(isHidden: Bool)
}
