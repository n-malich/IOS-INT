//
//  PostViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import StorageService

protocol PostViewControllerCoordinatorDelegate: AnyObject {
    func navigateToNextPage()
}

class PostViewController: UIViewController {
    
    weak var coordinator: PostViewControllerCoordinatorDelegate?
    
    var post = PostOnFeed(title: "Post")
    var buttonInfo = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        buttonInfo = UIBarButtonItem(image: UIImage.init(named: "info"), style: .plain, target: self, action: #selector(onInfoClick))
        self.navigationItem.rightBarButtonItem = buttonInfo
}

@objc func onInfoClick () {
    self.coordinator?.navigateToNextPage()
    }
}
