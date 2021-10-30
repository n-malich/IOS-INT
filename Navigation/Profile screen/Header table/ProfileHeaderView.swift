//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit
import SnapKit

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
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(baseInset)
            make.leading.equalToSuperview().inset(baseInset)
            make.width.height.equalTo(110)
        }
        
        animationView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(avatarImageView)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(baseInset)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(baseInset)
            make.trailing.equalToSuperview().inset(-baseInset)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(34)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(baseInset)
            make.trailing.equalToSuperview().inset(baseInset)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(baseInset)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(baseInset)
            make.trailing.equalToSuperview().inset(baseInset)
            make.height.equalTo(40)
        }
        
        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(baseInset)
            make.leading.equalToSuperview().inset(baseInset)
            make.trailing.equalToSuperview().inset(baseInset)
            make.bottom.equalToSuperview().inset(baseInset)
            make.height.equalTo(50)
        }
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
