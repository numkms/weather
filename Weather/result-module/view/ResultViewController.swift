//
//  ResultViewController.swift
//  Weather
//
//  Created by Владимир Курдюков on 06.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var presentor: ResultViewToPresenterProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var tableViewSections: [ResultTableSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeMarkup()
        buildResult()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func makeMarkup() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    func buildResult() {
        presentor?.interactor?.buildResult()
    }
    
    @objc func share() {
        presentor?.interactor?.shareResult()
    }
}

extension ResultViewController: ResultPresenterToViewProtocol {
    func showError(by message: String) {
        let alertVC = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "ОК", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    
    func shareResult(by message: String) {
        let textShare = [ message ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func displayResult(by sections: [ResultTableSection]) {
        tableViewSections = sections
        tableView.reloadData()
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSections[section].header
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        //For Header Background Color
        view.tintColor = tableViewSections[section].color
        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = tableViewSections[indexPath.section].rows[indexPath.row]
        let cell = UITableViewCell(style: cellData.style , reuseIdentifier: nil)
        cell.textLabel?.text = cellData.label
        cell.detailTextLabel?.text = cellData.value
        return cell
    }
}
