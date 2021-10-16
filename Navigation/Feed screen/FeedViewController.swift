//
//  FeedViewController.swift
//  Navigation
//
//  Created by Natali Mizina on 15.07.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    var post = Post(title: "Selected post")
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let buttonOnPost1: UIButton = {
        let button = UIButton()
        button.setTitle("Open post 1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(onPostClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonOnPost2: UIButton = {
        let button = UIButton()
        button.setTitle("Open post 2", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(onPostClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        self.navigationItem.title = "Feed"
        
        setupViews()
        setupConstraints()
    }
    
    @objc func onPostClick () {
        let postVC = PostViewController()
        postVC.post = post
        navigationController?.pushViewController(postVC, animated: true)
    }
}

extension FeedViewController {
    private func setupViews() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(buttonOnPost1)
        stackView.addArrangedSubview(buttonOnPost2)
    }
}

extension FeedViewController {
    private func setupConstraints() {
        [
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            buttonOnPost1.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonOnPost1.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            buttonOnPost1.heightAnchor.constraint(equalToConstant: 50),
            buttonOnPost1.widthAnchor.constraint(equalToConstant: 200),
            
            buttonOnPost2.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonOnPost2.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            buttonOnPost2.heightAnchor.constraint(equalTo: buttonOnPost1.heightAnchor, multiplier: 1),
            buttonOnPost2.widthAnchor.constraint(equalTo: buttonOnPost1.widthAnchor, multiplier: 1)
        ]
        .forEach {$0.isActive = true}
    }
}
