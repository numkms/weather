//
//  SelectPlaceProtocols.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

protocol SelectPlaceViewToPresenterProtocol: class {
    var view: SelectPlacePresenterToViewProtocol? {get set}
    var interactor: SelectPlacePresenterToInteractorProtocol? {get set}
    var router: SelectPlacePresenterToRouterProtocol? {get set}
    
    func fetchPlaces(by query: String)
    func selectPlace(place: Place)
}

protocol SelectPlacePresenterToViewProtocol: class {
    func updatePlaces(places: [Place])
    func placeSelected()
    func showError(by message: String)
}

protocol SelectPlacePresenterToRouterProtocol: class {
    static func createModule()-> SelectPlaceViewController
}

protocol SelectPlacePresenterToInteractorProtocol: class {
    var presenter: SelectPlaceInteractorToPresenterProtocol? {get set}
    func fetchPlaces(by query: String)
    func selectPlace(place: Place)
}

protocol SelectPlaceInteractorToPresenterProtocol: class {
    func updatePlaces(places: [Place])
    func placeSelected()
    func showError(by message: String)
}
