//
//  LoginFactory.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

protocol LoginFactory {
    func createLoginInspector() -> LoginInspector
}

class MyLoginFactory: LoginFactory {
    func createLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
