//
//  SelectVacationPlaceViewController.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import UIKit

class SelectPlaceViewController: UIViewController {
    
    var presentor: SelectPlaceViewToPresenterProtocol?
    
    lazy var textField: UITextField = {
        let textField =  UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название места отпуска"
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView;
    }()
    
    var places: [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeMarkup()
        
        textField.becomeFirstResponder()
        textField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func makeMarkup() {
        self.view.addSubview(textField)
        self.view.addSubview(tableView)
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 7).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
}

extension SelectPlaceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 > 3 {
            self.presentor?.fetchPlaces(by: textField.text ?? "")
        }
        return true
    }
}

extension SelectPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.detailTextLabel?.text = self.places[indexPath.row].name + ", " + self.places[indexPath.row].country
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentor?.selectPlace(place: places[indexPath.row])
    }
}

extension SelectPlaceViewController: SelectPlaceInteractorToPresenterProtocol {
    func showError(by message: String) {
        let alertVC = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "ОК", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    
    func updatePlaces(places: [Place]) {
        self.places = places;
        self.tableView.reloadData();
    }
}

extension SelectPlaceViewController: SelectPlacePresenterToViewProtocol {
    func placeSelected() {
        self.navigationController?.popViewController(animated: true);
    }
}
