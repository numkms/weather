//
//  SelectPlaceModule.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

class SelectPlaceRouter : SelectPlacePresenterToRouterProtocol {
    
    static func createModule() -> SelectPlaceViewController {
        
        let view = storyboard.instantiateViewController(withIdentifier: "SelectVacationVC") as! SelectPlaceViewController
        
        let presenter: SelectPlaceViewToPresenterProtocol & SelectPlaceInteractorToPresenterProtocol = SelectPlacePresenter()
        let interactor: SelectPlacePresenterToInteractorProtocol = SelectPlaceInteractor()
        let router: SelectPlacePresenterToRouterProtocol = SelectPlaceRouter()
        
        view.presentor = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name:"SelectPlaceStoryboard", bundle: Bundle.main)
    }
    
}
