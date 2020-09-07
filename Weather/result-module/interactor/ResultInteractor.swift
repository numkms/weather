//
//  ResultInteractor.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation

class ResultInteractor: ResultPresenterToInteractorProtocol {
    func shareResult() {
        ResultBuilder.build(completionString: { result in
            switch result {
            case .success(let message):
                self.presenter?.shareResult(by: message)
            case .failure(let error):
                switch  error {
                case .getDataErrors(let errors):
                    self.presenter?.showError(by: errors.reduce("", { $0 + "\($1)\n"}))
                }
            }
        })
    }
    
    func buildResult() {
        ResultBuilder.build(completion: { result in
            switch result {
            case .success(let model):
                self.presenter?.displayResult(by: model)
            case .failure(let error):
                switch error {
                case .getDataErrors(let errors):
                    self.presenter?.showError(by: errors.reduce("", { $0 + "\($1)\n"}))
                }
            }
            
        })
    }
    
    var presenter: ResultInteractorToPresenterProtocol?
}


