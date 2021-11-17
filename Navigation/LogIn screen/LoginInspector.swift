//
//  LoginInspector.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

class LoginInspector: LoginViewControllerDelegate {
    func checkTextFields(enteredLogin: String, enteredPassword: String) -> Bool {
        return Checker.shared.checkLoginAndPassword(enteredLogin: enteredLogin, enteredPassword: enteredPassword)
    }
}
