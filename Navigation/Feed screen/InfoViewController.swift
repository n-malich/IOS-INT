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
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        setupViews()
        setupConstraints()
        
        NetworkService.performRequest(returnedTitle: {(result: String) in
            self.label.text = result})
    }
}
extension InfoViewController {
    private func setupViews() {
        [button, label]
            .forEach {view.addSubview($0)}
    }
}

extension InfoViewController {
    private func setupConstraints() {
        [
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 300)
        ]
            .forEach {$0.isActive = true}
    }
}
