//
//  User.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class User {
    var firstName: String
    var lastName: String
    var email: String
    let id: String
    var status: String?
    var image: UIImage?
    var posts: [Post]
    var photos: [UIImage]
    
    init(firstName: String, lastName: String, email: String, id: String, status: String?, image: UIImage?, posts: [Post], photos: [UIImage]){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
        self.status = status
        self.image = image
        self.posts = posts
        self.photos = photos
    }
}
