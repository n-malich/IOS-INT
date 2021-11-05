//
//  PostViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class PostViewController: UIViewController {
    
    lazy var post = Post(title: "")
    private var buttonInfo = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        self.title = post.title
        
    buttonInfo = UIBarButtonItem(image: UIImage.init(named: "info"), style: .plain, target: self, action: #selector(onInfoClick))
        self.navigationItem.rightBarButtonItem = buttonInfo
}

@objc private func onInfoClick () {
    let infoVC = InfoViewController()
    infoVC.modalPresentationStyle = .formSheet
    infoVC.modalTransitionStyle = .coverVertical
    self.present(infoVC, animated: true, completion: nil)
    }
}


