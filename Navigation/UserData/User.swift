//
//  User.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import RealmSwift
import SwiftUI

class User: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var email: String
    @Persisted var password: String
    @Persisted var status: String?
    
    convenience init(firstName:String, lastName:String, email: String, password: String, status: String?) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.status = status
        self.id = id
    }
}

//class User {
//    var firstName: String
//    var lastName: String
//    var email: String
//    let id: String
//    var status: String?
//    var image: UIImage?
//    var posts: [Post]
//    var photos: [UIImage]
//
//    init(firstName: String, lastName: String, email: String, id: String, status: String?, image: UIImage?, posts: [Post], photos: [UIImage]){
//        self.firstName = firstName
//        self.lastName = lastName
//        self.email = email
//        self.id = id
//        self.status = status
//        self.image = image
//        self.posts = posts
//        self.photos = photos
//    }
//}
