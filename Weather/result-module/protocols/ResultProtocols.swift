//
//  ResultProtocols.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import UIKit

protocol ResultViewToPresenterProtocol: class {
    var view: ResultPresenterToViewProtocol? {get set}
    var interactor: ResultPresenterToInteractorProtocol? {get set}
    var router: ResultPresenterToRouterProtocol? {get set}
}

protocol ResultPresenterToViewProtocol: class {
    func displayResult(by sections: [ResultTableSection])
    func shareResult(by message: String)
    func showError(by message: String)
}

protocol ResultPresenterToRouterProtocol: class {
    static func createModule()-> ResultViewController
}

protocol ResultPresenterToInteractorProtocol: class {
    var presenter: ResultInteractorToPresenterProtocol? {get set}
    func buildResult();
    func shareResult()
}

protocol ResultInteractorToPresenterProtocol: class {
    func displayResult(by model: ResultModel)
    func shareResult(by message: String)
    func showError(by message: String)
}
