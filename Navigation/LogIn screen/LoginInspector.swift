//
//  LoginInspector.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import FirebaseAuth

class LoginInspector: LoginViewControllerDelegate {
    
    func signIn(enteredLogin: String, enteredPassword: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: enteredLogin, password: enteredPassword) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                onError()
            } else {
                print("Пользователь авторизован")
                onSuccess()
            }
        }
    }
    
    func signUp(enteredLogin: String, enteredPassword: String) {
        Auth.auth().createUser(withEmail: enteredLogin, password: enteredPassword) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Пользователь зарегистрировался")
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Пользователь вышел")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
