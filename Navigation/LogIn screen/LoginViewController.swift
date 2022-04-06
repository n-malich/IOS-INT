//
//  LoginViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import SwiftUI

protocol LoginViewControllerCoordinatorDelegate: AnyObject {
    func navigateToNextPage()
}

protocol LoginViewControllerDelegate: AnyObject {
    func signIn(enteredLogin: String, enteredPassword: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void)
    func signUp(enteredLogin: String, enteredPassword: String)
    func signOut()
}

class LoginViewController: UIViewController {
    
    var mode = ModeLoginViewController.logIn
    var coordinator: LoginViewControllerCoordinatorDelegate?
    var delegate: LoginViewControllerDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelMode: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 81/256, green: 129/256, blue: 184/256, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//    private lazy var firstNameTextField: CustomTextField = {
//        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "First name")
//        textField.layer.cornerRadius = 10
//        textField.layer.borderWidth = 0.5
//        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.clearButtonMode = UITextField.ViewMode.whileEditing
//        textField.returnKeyType = UIReturnKeyType.done
//        textField.clipsToBounds = true
//        textField.isHidden = true
//        return textField
//    }()
//
//    private lazy var lastNameTextField: CustomTextField = {
//        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Last name")
//        textField.layer.borderWidth = 0.5
//        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.clearButtonMode = UITextField.ViewMode.whileEditing
//        textField.returnKeyType = UIReturnKeyType.done
//        textField.clipsToBounds = true
//        textField.isHidden = true
//        return textField
//    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Email")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.clipsToBounds = true
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Password")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.clipsToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.isSecureTextEntry = true
        return textField
    }()
    
//    private lazy var confirmPasswordTextField: CustomTextField = {
//        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Confirm password")
//        textField.layer.cornerRadius = 10
//        textField.layer.borderWidth = 0.5
//        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.clearButtonMode = UITextField.ViewMode.whileEditing
//        textField.clipsToBounds = true
//        textField.returnKeyType = UIReturnKeyType.done
//        textField.isSecureTextEntry = true
//        textField.isHidden = true
//        return textField
//    }()
    
    private lazy var logInButton: CustomButton = {
        let button = CustomButton(title: "Log in", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
            if self?.mode == .registration {
                if let email = self?.emailTextField.text, !email.isEmpty, let password = self?.passwordTextField.text, !password.isEmpty, password.count >= 6 {
                    self?.delegate?.signUp(enteredLogin: email, enteredPassword: password)
                    self?.coordinator?.navigateToNextPage()
                    self?.showTruthAlert(message: "Вы успешно зарегистрированы")
                } else if let password = self?.passwordTextField.text, password.count < 6 {
                    self?.showErrorAlert(message: "Пароль должен быть не менее 6 символов")
                } else {
                    self?.showErrorAlert(message: "Введите адрес электронной почты и пароль")
                }
            } else {
                if let email = self?.emailTextField.text, !email.isEmpty,
                   let password = self?.passwordTextField.text, !password.isEmpty {
                    self?.delegate?.signIn(enteredLogin: email, enteredPassword: password, onSuccess: {
                        self?.coordinator?.navigateToNextPage()
                    }, onError: {
                        self?.showErrorAlert(message: "Неверный адрес электронной почты или пароль")
                    })
                } else {
                    self?.showErrorAlert(message: "Ввидите адрес электронной почты и пароль")
                }
            }
        })
        button.alpha = 1
        if button.isSelected || !button.isEnabled || button.isHighlighted { button.alpha = 0.8 }
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var cancelButton: CustomButton = {
        let button = CustomButton(title: "Cancel", titleColor: .systemBlue, backgroundColor: nil, backgroundImage: nil, buttonAction: { [weak self] in
            self?.mode = .logIn
            
            self?.emailTextField.text = ""
            self?.passwordTextField.text = ""
            self?.labelMode.isHidden = true
            self?.labelMode.text = ""
            
//            self?.firstNameTextField.isHidden = true
//            self?.lastNameTextField.isHidden = true
//            self?.confirmPasswordTextField.isHidden = true
            self?.cancelButton.isHidden = true
            self?.logInButton.setTitle("Log in", for: .normal)
            
//            self?.emailTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            self?.passwordTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            self?.questionLabel.isHidden = false
            self?.signUpButton.isHidden = false
        })
        button.isHidden = true
        return button
    }()
    
    private lazy var signUpButton: CustomButton = {
        let button = CustomButton(title: "Sign up", titleColor: .systemBlue, backgroundColor: nil, backgroundImage: nil, buttonAction: { [weak self] in
            self?.mode = .registration
            
            self?.emailTextField.text = ""
            self?.passwordTextField.text = ""
            
            self?.labelMode.isHidden = false
            self?.labelMode.text = "Create Account"
            
//            self?.firstNameTextField.isHidden = false
//            self?.lastNameTextField.isHidden = false
//            self?.confirmPasswordTextField.isHidden = false
            self?.cancelButton.isHidden = false
            self?.logInButton.setTitle("Create", for: .normal)
            
//            self?.firstNameTextField.tag = 0
//            self?.lastNameTextField.tag = 1
//            self?.emailTextField.tag = 2
//            self?.passwordTextField.tag = 3
//            self?.confirmPasswordTextField.tag = 4
            
//            self?.emailTextField.layer.maskedCorners = []
//            self?.passwordTextField.layer.maskedCorners = []
            
            self?.questionLabel.isHidden = true
            self?.signUpButton.isHidden = true
        })
        return button
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Not registered yet?"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var baseInset: CGFloat { return 16 }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        firstNameTextField.delegate = self
//        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
//        confirmPasswordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        setupViews()
        setupConstraints()
        setupHideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
        
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension LoginViewController {
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func showTruthAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
        private func setupViews() {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            [logoImageView, labelMode, stackView, logInButton, cancelButton, questionLabel, signUpButton].forEach { contentView.addSubview($0)}
//            [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach { stackView.addArrangedSubview($0)}
            [emailTextField, passwordTextField].forEach { stackView.addArrangedSubview($0)}
        }
    }

extension LoginViewController {
    private func setupConstraints() {
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelMode.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            labelMode.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            stackView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            
//            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
//
//            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
//            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: baseInset),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor),
            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            questionLabel.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 150),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 110),
            questionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            questionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 150),
            signUpButton.leadingAnchor.constraint(equalTo: questionLabel.trailingAnchor, constant: 10),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        .forEach {$0.isActive = true}
    }
}

extension LoginViewController: UITextFieldDelegate {
    //Переключение между TextField при нажатии клавиши Done в режимах logIn и registration
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController {
    //Скрытие keyboard при нажатии за пределами TextField
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
