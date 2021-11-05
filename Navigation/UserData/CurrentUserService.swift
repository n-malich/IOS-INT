//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit

final class CurrentUserService: UserService {
    private var user = User(userName: "Danya",
                           userStatus: "I like to sleep a lot",
                           userImage: (UIImage(named: "avatarImage") ?? UIImage.add))
    
    internal func getUser(userName: String) -> User? {
        if userName == user.userName {
            return user
        }
            return nil
    }
}
