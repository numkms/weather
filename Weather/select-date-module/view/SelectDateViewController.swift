//
//  SelectVacationDateViewController.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController {
    var presentor: SelectDateViewToPresenterProtocol?
    
    lazy var textField: UITextField = {
        let textField = UITextField();
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Выберите дату"
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker =  UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeMarkup()
        textField.becomeFirstResponder()
        textField.text = datePicker.date.formatForDisplay()
        presentor?.interactor?.setDate()
    }
    
    func makeMarkup() {
        self.view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 7).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.textField.inputView = datePicker
        self.title = "Выберите дату"
        self.navigationItem.rightBarButtonItem = .init(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(save)
        )
        
    }
    
    @objc func save() {
        presentor?.interactor?.update(date: datePicker.date);
    }
    
    @objc func timeChanged() {
        textField.text = datePicker.date.formatForDisplay()
    }
}

extension SelectDateViewController: SelectDateInteractorToPresenterProtocol {
    func dateUpdated() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setDate(date: Date) {
        datePicker.date = date
    }
}

extension SelectDateViewController: SelectDatePresenterToViewProtocol {
}
