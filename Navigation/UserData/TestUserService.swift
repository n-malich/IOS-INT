//
//  TestUserService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit

final class TestUserService: UserService {
    private var testUser = User(userName: "Anonymous",
                                userStatus: "Your status",
                                userImage: (UIImage.add))

    internal func getUser(userName: String) -> User? {
        if userName == testUser.userName {
            return testUser
        }
            return nil
    }
}
