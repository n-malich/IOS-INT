//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseDatabase

class ProfileHeaderView: UIView {
    
    var userID = CurrentUserService.shared.currentUser?.id
    private var baseInset: CGFloat = 16
    private var statusText: String? {
        didSet {
            statusLabel.text = statusText
        }
    }
    
    lazy var avatarImageView: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 55
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setStatusButton: CustomButton = {
        let button = CustomButton(title: "Set status", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
            
            if let text = self?.statusTextField.text, !text.isEmpty {
                self?.statusText = text
                self?.statusTextField.text = ""
                DispatchQueue.main.async {
                    Database.database().reference().child("users/\((self?.userID)!)/status").setValue(text) { (error: Error?, ref: DatabaseReference) in
                        if let error = error {
                            self?.statusText = ""
                            print("Status could not be saved: \(error)")
                        } else {
                            print("Status saved successfully!")
                        }
                    }
                }
            }
        })
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var statusTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 15), textColor: .black, backgroundColor: .white, placeholder: "Write your status")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.clipsToBounds = true
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        nil
    }
}

extension ProfileHeaderView {
    private func setupViews(){

        [fullNameLabel, statusLabel, statusTextField, setStatusButton, animationView, avatarImageView].forEach { self.addSubview ($0) }
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
            make.height.equalTo(14)
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
