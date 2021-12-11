//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class LoginCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
   
    let navigationController: UINavigationController
    
    var childCoordinators = [CoordinatorProtocol]()
    
    required init() {
        self.navigationController = .init()
    }
    
    func openLoginViewController() {
        let loginViewController: LoginViewController = LoginViewController()
        self.navigationController.isNavigationBarHidden = true
        loginViewController.coordinator = self
        loginViewController.delegate = MyLoginFactory().createLoginInspector()
        self.navigationController.viewControllers = [loginViewController]
    }
}

extension LoginCoordinator: LoginViewControllerCoordinatorDelegate {
    func navigateToNextPage(userName: String) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.delegate = self
        childCoordinators.append(profileCoordinator)
        profileCoordinator.openProfileViewController(userName: userName)
    }
}

extension LoginCoordinator: BackToLoginViewControllerDelegate {
    func navigateToPreviousPage(newOrderCoordinator: ProfileCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
