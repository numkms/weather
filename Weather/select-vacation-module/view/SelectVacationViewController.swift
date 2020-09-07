//
//  SelectVacationViewController.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import UIKit

class SelectVacationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultButton: UIButton!
    
    lazy var windPickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .init(x: 0, y: 50, width: 260, height: 300))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var temperaturePickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .init(x: 0, y: 50, width: 260, height: 300))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var precipitationPickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .init(x: 0, y: 50, width: 260, height: 300))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    var presentor: ViewToPresenterProtocol?
    var tableAdapter: SelectVacationTableAdapter!
    var pickerViewTitles: [PickerDataModel] = [];
    
    
    @IBAction func goToResult(_ sender: Any) {
        self.presentor?.router?.pushToResult(by: navigationController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdapter = .init(tableView: tableView)
        
        presentor?.buildTableByModel()
        presentor?.interactor?.loadMyWeather()
        
        self.navigationItem.rightBarButtonItem = .init(title: "+ Место отдыха", style: .done, target: self, action: #selector(selectPlace))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentor?.buildTableByModel()
    }
    
    @objc func selectPlace() {
        presentor?.router?.pushToSelectPlace(by: navigationController);
    }
}

extension SelectVacationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerViewTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewTitles[row].value
    }
    
    func showAlertPicker(title: String, pickerView: UIPickerView, pickerType: SelectWeatherPickerType) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet);
        alert.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            if let selectedData = self?.pickerViewTitles[pickerView.selectedRow(inComponent: 0)] {
                switch pickerType {
                case .precipation:
                    self?.presentor?.updateWeatherModelValue(precipation: selectedData.key)
                case .temperature:
                    self?.presentor?.updateWeatherModelValue(temperature: selectedData.key)
                case .wind:
                    self?.presentor?.updateWeatherModelValue(wind: selectedData.key)
                }
            }
        })
        alert.addAction(action)
        
        pickerView.frame.size.width = alert.view.frame.size.width
        alert.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor).isActive = true
        alert.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor).isActive = true
        alert.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        alert.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 40).isActive = true
        
        present(alert, animated: true);
    }
}

extension SelectVacationViewController: PresenterToViewProtocol {
    func showError(by message: String) {
        let alertVC = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "ОК", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    
    func updateTable(sections: [SelectVacationTableViewSection]) {
        tableAdapter.set(sections: sections)
    }
    
    func setResultButton(isHidden: Bool) {
        resultButton.isEnabled = !isHidden
    }
    
    func selectTemperature(temperatures: [PickerDataModel]) {
        pickerViewTitles = temperatures
        showAlertPicker(title: "Выберите температуру", pickerView: temperaturePickerView, pickerType: .temperature)
    }
    
    func selectPrecipitation(precipitations: [PickerDataModel]) {
        pickerViewTitles = precipitations
        showAlertPicker(title: "Уровень осадков", pickerView: precipitationPickerView, pickerType: .precipation)
    }
    
    func selectWind(windsVlaues: [PickerDataModel]) {
        pickerViewTitles = windsVlaues
        showAlertPicker(title: "Выберите интенсивность ветра", pickerView: windPickerView, pickerType: .wind)
    }
    
    func pushToSelectDate(type: SelectVacationService.DateType) {
        self.presentor?.router?.pushToSelectDate(by: navigationController, type: type)
    }
}
