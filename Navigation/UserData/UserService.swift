//
//  UserService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

protocol UserService {
    func getUser (userName: String) -> User?
}
