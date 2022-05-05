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
    
    func openProfileViewController() {
        guard let user = CurrentUserService.shared.readUser() else { return }
        let profileViewController: ProfileViewController = ProfileViewController(user: user)
        profileViewController.coordinator = self
        profileViewController.delegate = MyLoginFactory().createLoginInspector()
        self.navigationController.viewControllers.append(profileViewController)
    }
}

extension ProfileCoordinator: ProfileViewControllerCoordinatorDelegate {
    func navigateToNextPage() {
        let photosCoordinator = PhotosCoordinator(navigationController: navigationController)
//        photosCoordinator.delegate = self
        childCoordinators.append(photosCoordinator)
        photosCoordinator.openPhotosViewController()
    }
    
    func navigateToPreviousPage() {
        self.delegate?.navigateToPreviousPage(newOrderCoordinator: self)
    }
}
