//
//  PostViewController.swift
//  Navigation
//
//  Created by Natali Mizina on 15.07.2021.
//

import UIKit

class PostViewController: UIViewController {
    
    var post = Post(title: "")
    var buttonInfo = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        self.title = post.title
        
    buttonInfo = UIBarButtonItem(image: UIImage.init(named: "info"), style: .plain, target: self, action: #selector(onInfoClick))
        self.navigationItem.rightBarButtonItem = buttonInfo
}

@objc func onInfoClick () {
    let infoVC = InfoViewController()
    infoVC.modalPresentationStyle = .formSheet
    infoVC.modalTransitionStyle = .coverVertical
    self.present(infoVC, animated: true, completion: nil)
    }
}


