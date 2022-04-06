//
//  UserServiceProtocol.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

protocol UserServiceProtocol {
    func getUser(userName: String) -> User?
}
