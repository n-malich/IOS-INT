//
//  LoginInspector.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol LoginFactory {
    func createLoginInspector() -> LoginInspector
}

class MyLoginFactory: LoginFactory {
    func createLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}

class LoginInspector: LoginViewControllerDelegate {
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                Database.database().reference().child("users").child((user?.user.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? [String: Any]
                    let firstName = value?["firstName"] as? String ?? "Unknown"
                    let lastName = value?["lastName"] as? String ?? "Unknown"
                    let email = value?["email"] as? String ?? "Unknown"
                    let id = value?["id"] as? String ?? "Unknown"
                    let status = value?["status"] as? String ?? ""
                    
                    let user = User(firstName: firstName, lastName: lastName, email: email, id: id, status: status, image: UIImage(named: "avatarImage"), posts: Posts().postsArray, photos: Photos().photosArray)
                    CurrentUserService.shared.writeUser(user: user)
                    print("User signed in")
                    completion(true)
                }) { error in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                Database.database().reference().child("users").child((user?.user.uid)!).setValue(["firstName":firstName, "lastName": lastName, "email": email, "id":user?.user.uid]) { (error: Error?, ref: DatabaseReference) in
                    if let error = error {
                        print("User could not be saved: \(error)")
                    } else {
                        let user = User(firstName: firstName, lastName: lastName, email: email, id: ((user?.user.uid)!), status: nil, image: UIImage(named: "avatarImage"), posts: Posts().postsArray, photos: Photos().photosArray)
                        CurrentUserService.shared.writeUser(user: user)
                        print("User saved successfully!")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try  Auth.auth().signOut()
            Database.database().reference().removeAllObservers()
            print("User signed out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
