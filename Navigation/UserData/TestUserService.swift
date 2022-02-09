//
//  TestUserService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit

class TestUserService: UserServiceProtocol {
    private var testUser = User(userName: "Anonymous",
                                userStatus: "Your status",
                                userImage: (UIImage()))
    
    func getUser(userName: String) -> User? {
        if userName == testUser.userName {
            return testUser
        }
        return nil
    }
}
