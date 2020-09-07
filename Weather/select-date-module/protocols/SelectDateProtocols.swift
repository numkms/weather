//
//  SelectDateProtocols.swift
//  Weather
//
//  Created by Владимир Курдюков on 05.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

protocol SelectDateViewToPresenterProtocol: class {
    var view: SelectDatePresenterToViewProtocol? {get set}
    var interactor: SelectDatePresenterToInteractorProtocol? {get set}
    var router: SelectDatePresenterToRouterProtocol? {get set}
}

protocol SelectDatePresenterToViewProtocol: class {
    func dateUpdated()
    func setDate(date: Date)
}

protocol SelectDatePresenterToRouterProtocol: class {
    static func createModule<T: SelectDatePresenterToInteractorProtocol>(withInteractor interactor: T) -> SelectDateViewController
}

protocol SelectDatePresenterToInteractorProtocol: class {
    var presenter: SelectDateInteractorToPresenterProtocol? {get set}
    func update(date: Date);
    func setDate();
}

protocol SelectDateInteractorToPresenterProtocol: class {
    func dateUpdated()
    func setDate(date: Date)
}
