//
//  User.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit

class User {
    var userName: String
    var userStatus: String
    var userImage: UIImage
    
    init(userName: String, userStatus: String, userImage: UIImage){
        self.userName = userName
        self.userStatus = userStatus
        self.userImage = userImage
    }
}
