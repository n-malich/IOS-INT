//
//  UserServiceProtocol.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

protocol UserServiceProtocol {
    var currentUser: User? { get set }

    func writeUser(user: User)
    func readUser() -> User?
}

final class CurrentUserService: UserServiceProtocol {
    static let shared = CurrentUserService()
    var currentUser: User?
    
    func writeUser(user: User) {
        self.currentUser = user
    }
    
    func readUser() -> User? {
        self.currentUser
    }
}
