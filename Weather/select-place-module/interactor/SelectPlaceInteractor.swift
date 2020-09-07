//
//  SelectPlaceInteractor.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

class SelectPlaceInteractor: SelectPlacePresenterToInteractorProtocol {
    var presenter: SelectPlaceInteractorToPresenterProtocol?
    
    func fetchPlaces(by query: String) {
        ApiManager.weatherApi.cityList(by: query) { result in
            switch result {
            case .success(let places):
                self.presenter?.updatePlaces(places: places)
            case .failure(let error):
                switch error {
                case .decodingError(let error), .requestError(let error):
                    self.presenter?.showError(by: error);
                }
            }
        }
    }
    
    func selectPlace(place: Place) {
        SelectVacationService.shared.add(place: place)
        self.presenter?.placeSelected()
    }
    
}
