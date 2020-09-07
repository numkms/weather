//
//  SelectVacationRouter.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

class SelectVacationRouter : PresenterToRouterProtocol {
    
    static func createModule() -> SelectVacationViewController {
        
        let view = storyboard.instantiateViewController(withIdentifier: "SelectVacationVC") as! SelectVacationViewController
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = SelectVacationPresenter()
        let interactor: PresenterToInteractorProtocol = SelectVacationInteractor()
        let router:PresenterToRouterProtocol = SelectVacationRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name:"SelectVacationStoryboard", bundle: Bundle.main)
    }
    
    func pushToSelectPlace(by navigationController: UINavigationController?) {
        let selectPlaceModule = SelectPlaceRouter.createModule()
        navigationController?.pushViewController(selectPlaceModule, animated: true)
    }
    
    func modalSelectPlace(by uIViewController: UIViewController) {
        let selectPlaceModule = SelectPlaceRouter.createModule()
        uIViewController.present(selectPlaceModule, animated: true);
    }
    
    func pushToSelectDate(by navigationController: UINavigationController?, type: SelectVacationService.DateType) {
        let selectDateModule = type == .from ? SelectDateRouter.createModule(withInteractor: SelectDateVacationFromInteractor()) : SelectDateRouter.createModule(withInteractor: SelectDateVacationToInteractor())
        navigationController?.pushViewController(selectDateModule, animated: true)
    }
    
    func pushToResult(by navigationController: UINavigationController?) {
        let resultModule = ResultRouter.createModule()
        navigationController?.pushViewController(resultModule, animated: true)
    }
}
