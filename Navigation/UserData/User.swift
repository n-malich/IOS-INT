//
//  User.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit

public final class User {
    public var userName: String
    public var userStatus: String
    public var userImage: UIImage
    
    init(userName: String, userStatus: String, userImage: UIImage){
        self.userName = userName
        self.userStatus = userStatus
        self.userImage = userImage
    }
}
