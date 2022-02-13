//
//  InfoViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var button: CustomButton = {
        let button = CustomButton(title: "Press me", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
            let alertC = UIAlertController(title: "Error", message: "Nothing found", preferredStyle: UIAlertController.Style.alert)
            alertC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in print("Ok")}))
            alertC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in print("Cancel")}))
            self?.present(alertC, animated: true, completion: nil)
        })
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameResidents = [String?]()
    
    private lazy var residentID = String(describing: TableViewCellResident.self)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        setupViews()
        setupConstraints()
        
        tableView.register(TableViewCellResident.self, forCellReuseIdentifier: residentID)
        tableView.dataSource = self
        
        NetworkService.getResidents(returnedResinents: {(result: [String]) in
            self.label.text = "Rundom name: \(result.randomElement() ?? "")"
            self.nameResidents = result
            self.tableView.reloadData()
        })
    }
}
extension InfoViewController {
    private func setupViews() {
        [button, label, tableView]
            .forEach {view.addSubview($0)}
    }
}

extension InfoViewController {
    private func setupConstraints() {
        [
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 300),
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ]
            .forEach {$0.isActive = true}
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameResidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCellResident = tableView.dequeueReusableCell(withIdentifier: residentID, for: indexPath) as! TableViewCellResident
        if let nameResidents = nameResidents[indexPath.row] {
            cell.nameResident.text = nameResidents.description
            cell.selectionStyle = .none
        } else {
            return UITableViewCell()
        }
        return cell
    }
}
