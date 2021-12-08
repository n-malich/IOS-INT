//
//  Checker.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

class Checker {
    static var shared: Checker = {
        let instance = Checker()
        return instance
    }()
    
    #if DEBUG
    private let loginUser = "Anonymous"
    #else
    private let loginUser = "Danya"
    #endif
    
//    private let passwordUser = "Password"
    private let passwordUser = "Pass"
    
    private init() {}
    
    func checkLoginAndPassword(enteredLogin: String, enteredPassword: String) -> Bool {
        loginUser == enteredLogin && passwordUser == enteredPassword
    }
}
