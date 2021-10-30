//
//  InfoViewController.swift
//  Navigation
//
//  Created by Natali Mizina on 15.07.2021.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        let button = UIButton(frame: CGRect(x: 125, y: 350, width: 200, height: 50))
        button.setTitle("Press me", for: .normal)
        button.addTarget(self, action: #selector(onAlertClick), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(onAlertClick), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func onAlertClick () {
        let alertVC = UIAlertController(title: "Error", message: "Nothing found", preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in print("Some text")}))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in print("Some more text")}))
        present(alertVC, animated: true, completion: nil)
    }

}
