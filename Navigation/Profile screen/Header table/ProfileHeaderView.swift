//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Natali Mizina on 21.07.2021.
//

import Foundation
import UIKit

class ProfileHeaderView: UIView {
    
    let avatarImageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "avatarImage")
        image.layer.cornerRadius = 55
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Cat Danya"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Set up status"
        label.textColor = .gray
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(onSetStatus), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let statusTextField: UITextField = {
        var textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.text = "Waiting for something..."
        textField.textColor = .gray
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var baseInset: CGFloat { return 16 }
    
    private var statusText = String()
    
    let animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
    
        setupViews()
        setupConstraints()

        statusTextField.delegate = self

    }
    
    @objc func statusTextChanged() {
        if let text = statusTextField.text {
            statusText = text
        }
    }

    @objc func onSetStatus() {
        if statusText.isEmpty {
            statusText = "Set up status"
        }
        statusLabel.text = statusText
        self.endEditing(true)
    }
}

extension ProfileHeaderView {
    private func setupViews(){

        [fullNameLabel, statusLabel, statusTextField, setStatusButton, animationView, avatarImageView].forEach {self.addSubview ($0)}
    }
}

extension ProfileHeaderView {
    private func setupConstraints(){
        [
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: baseInset),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: baseInset),
            avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: baseInset),
            animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: baseInset),
            animationView.widthAnchor.constraint(equalToConstant: 110),
            animationView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: baseInset),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: baseInset),
            fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -baseInset),
            
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 34),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: baseInset),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -baseInset),
            
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: baseInset),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: baseInset),
            statusTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -baseInset),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: baseInset),
            setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -baseInset),
            setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -baseInset),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        .forEach {$0.isActive = true}
    }
}

 extension ProfileHeaderView : UITextFieldDelegate {
     //Скрытие подсказки во время редактирования TextField
     func textFieldDidBeginEditing(_ textField: UITextField) {
         if statusTextField.text == "Waiting for something..." {
             statusTextField.text = nil
             statusTextField.textColor = .black
         }
     }
     //Устанавливает подсказки в TextField и Label при условии isEmpty
     func textFieldDidEndEditing(_ textField: UITextField) {
         if let text = statusTextField.text, text.isEmpty {
             statusTextField.text = "Waiting for something..."
             statusTextField.textColor = .gray
             statusLabel.text = "Set up status"
         }
     }
    //Скрытие keyboard при нажатии клавиши Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        statusTextField.resignFirstResponder()
        return true
    }
}
