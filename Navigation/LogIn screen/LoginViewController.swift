//
//  LoginViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import SwiftUI
import RealmSwift
//import FirebaseAuth
//import FirebaseDatabase

protocol LoginViewControllerCoordinatorDelegate: AnyObject {
    func navigateToNextPage()
}

protocol LoginViewControllerDelegate: AnyObject {
//    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void)
    func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void)
    func signOut()
}

enum ModeLoginViewController {
//    case signIn
    case signUp
}

class LoginViewController: UIViewController {
    
    var coordinator: LoginViewControllerCoordinatorDelegate?
    var delegate: LoginViewControllerDelegate?
    private var mode: ModeLoginViewController?
    private var baseInset: CGFloat = 16
    
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
        label.text = "Create Account"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 81/256, green: 129/256, blue: 184/256, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var firstNameTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "First name")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.clipsToBounds = true
//        textField.isHidden = true
        return textField
    }()

    private lazy var lastNameTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Last name")
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.clipsToBounds = true
//        textField.isHidden = true
        return textField
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 16), textColor: .black, backgroundColor: .systemGray6, placeholder: "Email")
//        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
//        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
    
    private lazy var logInButton: CustomButton = {
//        let button = CustomButton(title: "Log in", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
        let button = CustomButton(title: "Create", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
            if self?.mode == .signUp {
                if let firstName = self?.firstNameTextField.text, !firstName.isEmpty, let lastName = self?.lastNameTextField.text, !firstName.isEmpty, let email = self?.emailTextField.text, !email.isEmpty, let password = self?.passwordTextField.text, !password.isEmpty, password.count >= 6 {
                    self?.delegate?.signUp(email: email, password: password, firstName: firstName, lastName: lastName, completion: { result in
                        if result {
                            self?.coordinator?.navigateToNextPage()
                            self?.showTruthAlert(message: "You have successfully registered!")
                        } else {
                            self?.showErrorAlert(message: "User could not be saved")
                        }
                    })
                } else if let password = self?.passwordTextField.text, password.count < 6 {
                    self?.showErrorAlert(message: "Password must be at least 6 characters")
                } else {
                    self?.showErrorAlert(message: "Enter your email address and password")
                }
//            } else {
//                if let email = self?.emailTextField.text, !email.isEmpty,
//                   let password = self?.passwordTextField.text, !password.isEmpty {
//                    self?.delegate?.signIn(email: email, password: password, completion: { result in
//                        if result {
//                            self?.coordinator?.navigateToNextPage()
//                        } else {
//                            self?.showErrorAlert(message: "Invalid email address or password")
//                        }
//                    })
//                } else {
//                    self?.showErrorAlert(message: "Enter your email address and password")
//                }
            }
        })
        button.alpha = 1
        if button.isSelected || !button.isEnabled || button.isHighlighted { button.alpha = 0.8 }
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
//    private lazy var cancelButton: CustomButton = {
//        let button = CustomButton(title: "Cancel", titleColor: .systemBlue, backgroundColor: nil, backgroundImage: nil, buttonAction: { [weak self] in
//            self?.mode = .signIn
            
//            self?.emailTextField.text = ""
//            self?.passwordTextField.text = ""
//            self?.labelMode.isHidden = true
//            self?.labelMode.text = ""
//
//            self?.firstNameTextField.isHidden = true
//            self?.lastNameTextField.isHidden = true
//            self?.cancelButton.isHidden = true
//            self?.logInButton.setTitle("Log in", for: .normal)
//
//            self?.emailTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            self?.passwordTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//
//            self?.questionLabel.isHidden = false
//            self?.signUpButton.isHidden = false
//        })
//        button.isHidden = true
//        return button
//    }()
    
//    private lazy var signUpButton: CustomButton = {
//        let button = CustomButton(title: "Sign up", titleColor: .systemBlue, backgroundColor: nil, backgroundImage: nil, buttonAction: { [weak self] in
//            self?.mode = .signUp
//
//            self?.emailTextField.text = ""
//            self?.passwordTextField.text = ""
//
//            self?.labelMode.isHidden = false
//            self?.labelMode.text = "Create Account"
//
//            self?.firstNameTextField.isHidden = false
//            self?.lastNameTextField.isHidden = false
//            self?.cancelButton.isHidden = false
//            self?.logInButton.setTitle("Create", for: .normal)
//
//            self?.firstNameTextField.tag = 0
//            self?.lastNameTextField.tag = 1
//            self?.emailTextField.tag = 2
//            self?.passwordTextField.tag = 3
//
//            self?.emailTextField.layer.maskedCorners = []
//
//            self?.questionLabel.isHidden = true
//            self?.signUpButton.isHidden = true
//        })
//        return button
//    }()
    
//    private lazy var questionLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.text = "Not registered yet?"
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.style = .large
//        activityIndicator.isHidden = true
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        return activityIndicator
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mode = .signUp
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        emailTextField.tag = 2
        passwordTextField.tag = 3
        
//        emailTextField.tag = 0
//        passwordTextField.tag = 1
        
        
        setupViews()
        setupConstraints()
        setupHideKeyboardOnTap()
        
        signInCurrentUser()
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
        emailTextField.text = ""
        passwordTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        
//        labelMode.isHidden = true
//        firstNameTextField.isHidden = true
//        lastNameTextField.isHidden = true
//        activityIndicator.isHidden = true
//        cancelButton.isHidden = true
//        emailTextField.isHidden = false
//        passwordTextField.isHidden = false
//        logInButton.isHidden = false
//        questionLabel.isHidden = false
//        signUpButton.isHidden = false
//
//        logInButton.setTitle("Log in", for: .normal)
//
//        emailTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func signInCurrentUser() {
        let realm = try! Realm()
        if realm.objects(User.self).count >= 1 {
            CurrentUserService.shared.writeUser(user: realm.objects(User.self)[0])
            self.coordinator?.navigateToNextPage()
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        print(realm.objects(User.self))
        
        
//        if Auth.auth().currentUser !== nil {
//            [emailTextField, passwordTextField, firstNameTextField, lastNameTextField, logInButton, questionLabel, signUpButton].forEach({ $0.isHidden = true })
//            activityIndicator.isHidden = false
//            activityIndicator.startAnimating()
//
//            let handle = Auth.auth().addStateDidChangeListener { auth, user in
//                Database.database().reference().child("users").child(user!.uid).observeSingleEvent(of: .value, with: { snapshot in
//                    let value = snapshot.value as? [String: Any]
//                    let firstName = value?["firstName"] as? String ?? "Unknown"
//                    let lastName = value?["lastName"] as? String ?? "Unknown"
//                    let email = value?["email"] as? String ?? "Unknown"
//                    let id = value?["id"] as? String ?? "Unknown"
//                    let status = value?["status"] as? String ?? ""
//
//                    let user = User(firstName: firstName, lastName: lastName, email: email, id: id, status: status, image: UIImage(named: "avatarImage"), posts: Posts().postsArray, photos: Photos().photosArray)
//                    CurrentUserService.shared.writeUser(user: user)
//                })
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [weak self] in
//                self?.activityIndicator.stopAnimating()
//                Auth.auth().removeStateDidChangeListener(handle)
//                self?.coordinator?.navigateToNextPage()
//                self?.firstNameTextField.isHidden = true
//                self?.lastNameTextField.isHidden = true
//                self?.activityIndicator.isHidden = true
//                self?.emailTextField.isHidden = false
//                self?.passwordTextField.isHidden = false
//                self?.logInButton.isHidden = false
//                self?.questionLabel.isHidden = false
//                self?.signUpButton.isHidden = false
//            })
//        }
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
        private func setupViews() {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
//            [logoImageView, labelMode, stackView, logInButton, cancelButton, questionLabel, signUpButton, activityIndicator].forEach { contentView.addSubview($0)}
            [logoImageView, labelMode, stackView, logInButton].forEach { contentView.addSubview($0)}
            [firstNameTextField, lastNameTextField, emailTextField, passwordTextField].forEach { stackView.addArrangedSubview($0)}
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
            
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),

            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: baseInset),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
//            cancelButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor),
//            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            cancelButton.heightAnchor.constraint(equalToConstant: 50),
//
//            questionLabel.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 150),
//            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 110),
//            questionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            questionLabel.heightAnchor.constraint(equalToConstant: 50),
//
//            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 150),
//            signUpButton.leadingAnchor.constraint(equalTo: questionLabel.trailingAnchor, constant: 10),
//            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            signUpButton.heightAnchor.constraint(equalToConstant: 50),
//
//            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        .forEach {$0.isActive = true}
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

extension LoginViewController: UITextFieldDelegate {
    //Переключение между TextField при нажатии клавиши Done в режимах signIn и signUp
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
