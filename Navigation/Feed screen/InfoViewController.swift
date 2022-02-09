//
//  InfoViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

//protocol InfoViewControllerCoordinatorDelegate: AnyObject {
//    func navigateToNextPage()
//}

class InfoViewController: UIViewController {
    
//    var coordinator: InfoViewControllerCoordinatorDelegate?
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        setupViews()
        setupConstraints()
    }
}
extension InfoViewController {
    private func setupViews() {
        view.addSubview(button)
    }
}

extension InfoViewController {
    private func setupConstraints() {
        [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 300)
        ]
        .forEach {$0.isActive = true}
    }
}
