//
//  SelectDateRouter.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

class SelectDateRouter: SelectDatePresenterToRouterProtocol {
    static func createModule<T: SelectDatePresenterToInteractorProtocol >(withInteractor interactor: T) -> SelectDateViewController {
        
        let view = storyboard.instantiateViewController(withIdentifier: "SelectDateVC") as! SelectDateViewController
        let presenter: SelectDateViewToPresenterProtocol & SelectDateInteractorToPresenterProtocol = SelectDatePresenter()
        let interactor: SelectDatePresenterToInteractorProtocol = interactor
        let router: SelectDatePresenterToRouterProtocol = SelectDateRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name:"SelectDateStoryboard", bundle: Bundle.main)
    }
}
