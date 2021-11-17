//
//  LoginFactory.swift
//  Navigation
//
//  Created by Natali Malich on 30.10.2021.
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
