//
//  LoginViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    
    let userService = CurrentUserService()
    let userServiceTest = TestUserService()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.placeholder = "Email of phone"
        textField.tintColor = UIColor(named: "colorSet")
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.clipsToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
   
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.tintColor = UIColor(named: "colorSet")
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.clipsToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
//    let logInButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Log in", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(loadUserProfile), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
//        button.setTitleColor(UIColor.init(white: 1, alpha: 0.8), for: .selected)
//        button.setTitleColor(UIColor.init(white: 1, alpha: 0.8), for: .highlighted)
//        button.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .disabled)
//        return button
//    }()
    
    //ДЗ 6.1 Кастомный класс UIButton
    private lazy var logInButton: CustomButton = {
        let button = CustomButton(title: "Log in", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
            #if DEBUG
            let userServise = TestUserService()
            #else
            let userServise = CurrentUserService()
            #endif
            if let email = self?.emailTextField.text, !email.isEmpty, let password = self?.passwordTextField.text, !password.isEmpty {
                if self?.delegate?.checkTextFields(enteredLogin: email, enteredPassword: password) == true {
                    let profileVC = ProfileViewController(userService: userServise, userName: email)
                    self?.navigationController?.pushViewController(profileVC, animated: true)
                } else {
                    self?.showAlert(message: "Неверный логин или пароль")
                }
            } else {
                self?.showAlert(message: "Ввидите имя пользователя и пароль")
            }
        })
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private var baseInset: CGFloat { return 16 }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
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
    
//    @objc func loadUserProfile() {
        //ДЗ 3 - чтобы попасть в профиль нужно ввести имя пользователя
//        if let userName = emailTextField.text, !userName.isEmpty {
//        #if DEBUG
//            if let user = userServiceTest.getUser(userName: userName) {
//                let profileVC = ProfileViewController(userService: userServiceTest.self, userName: user.userName)
//                navigationController?.pushViewController(profileVC, animated: true)
//            } else {
//                showAlert(message: "Пользователь не найден")
//            }
//        #else
//            if let user = userService.getUser(userName: userName){
//                let profileVC = ProfileViewController(userService: userService.self, userName: userName)
//                navigationController?.pushViewController(profileVC, animated: true)
//            } else {
//                showAlert(message: "Пользователь не найден")
//            }
//        #endif
//        } else {
//            showAlert(message: "Ввидите имя пользователя")
//        }
//    }
        
        //ДЗ 4.1 и 4.2
//        #if DEBUG
//        let userServise = TestUserService()
//        #else
//        let userServise = CurrentUserService()
//        #endif
//
//        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
//            if delegate?.checkTextFields(enteredLogin: email, enteredPassword: password) == true {
//                let profileVC = ProfileViewController(userService: userServise, userName: email)
//                navigationController?.pushViewController(profileVC, animated: true)
//            } else {
//                showAlert(message: "Неверный логин или пароль")
//            }
//        } else {
//            showAlert(message: "Ввидите имя пользователя и пароль")
//        }
//    }
}

extension LoginViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
        private func setupViews() {
            view.backgroundColor = .white
            
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            [logoImageView, emailTextField, passwordTextField, logInButton].forEach { contentView.addSubview($0)}
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
            
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: baseInset),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        .forEach {$0.isActive = true}
    }
}

extension LoginViewController: UITextFieldDelegate {
    //Переключение между TextField при нажатии клавиши Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
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
