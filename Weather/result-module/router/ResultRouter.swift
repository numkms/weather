//
//  ResultRouter.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

class ResultRouter : ResultPresenterToRouterProtocol {
    
    static func createModule() -> ResultViewController {
        
        let view = storyboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultViewController
        let presenter: ResultViewToPresenterProtocol & ResultInteractorToPresenterProtocol = ResultPresenter()
        let interactor: ResultPresenterToInteractorProtocol = ResultInteractor()
        let router: ResultPresenterToRouterProtocol = ResultRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name:"ResultStoryboard", bundle: Bundle.main)
    }

}
