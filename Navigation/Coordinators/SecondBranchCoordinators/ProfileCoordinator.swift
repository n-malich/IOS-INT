//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

protocol BackToLoginViewControllerDelegate: AnyObject {
    func navigateToPreviousPage(newOrderCoordinator: ProfileCoordinator)
}

class ProfileCoordinator: CoordinatorProtocol {
    
    weak var delegate: BackToLoginViewControllerDelegate?
    
    var childCoordinators = [CoordinatorProtocol]()
    
    unowned let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
//    func openProfileViewController(userName: String) {
//        #if DEBUG
//        let userServise = TestUserService()
//        #else
//        let userServise = CurrentUserService()
//        #endif
//        let profileViewController: ProfileViewController = ProfileViewController(userService: userServise, userName: userName)
    func openProfileViewController() {
        let profileViewController: ProfileViewController = ProfileViewController()
        profileViewController.coordinator = self
        self.navigationController.pushViewController(profileViewController, animated: true)
    }
}

extension ProfileCoordinator: ProfileViewControllerCoordinatorDelegate {
    func navigateToNextPage() {
//        let thirdViewController: ViewController = ViewController()
//        thirdViewController.delegate = self
//        self.navigationController.present(thirdViewController, animated: true, completion: nil)
    }
    
    func navigateToPreviousPage() {
        self.delegate?.navigateToPreviousPage(newOrderCoordinator: self)
    }
}
