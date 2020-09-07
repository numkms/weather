//
//  SelectPlacePresenter.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

class SelectPlacePresenter: SelectPlaceViewToPresenterProtocol {
    var view: SelectPlacePresenterToViewProtocol?
    var interactor: SelectPlacePresenterToInteractorProtocol?
    var router: SelectPlacePresenterToRouterProtocol?
    
    func fetchPlaces(by query: String) {
        interactor?.fetchPlaces(by: query)
    }
    
    func selectPlace(place: Place) {
        interactor?.selectPlace(place: place)
    }
}

extension SelectPlacePresenter: SelectPlaceInteractorToPresenterProtocol {
    func showError(by message: String) {
        view?.showError(by: message)
    }
    
    func updatePlaces(places: [Place]) {
        view?.updatePlaces(places: places);
    }
    
    func placeSelected() {
        view?.placeSelected();
    }
}
