//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func checkTextFields(enteredLogin: String, enteredPassword: String) -> Bool
}
