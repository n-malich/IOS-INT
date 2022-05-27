//
//  PhotosCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

protocol BackToProfileViewControllerDelegate: AnyObject {
    func navigateToPreviousPage(newOrderCoordinator: PhotosCoordinator)
}

class PhotosCoordinator: CoordinatorProtocol {
    
    weak var delegate: BackToProfileViewControllerDelegate?
    var childCoordinators = [CoordinatorProtocol]()
    unowned let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openPhotosViewController() {
        let photosViewController: PhotosViewController = PhotosViewController()
        photosViewController.coordinator = self
        self.navigationController.isNavigationBarHidden = false
        self.navigationController.navigationItem.backBarButtonItem?.style = .plain
        self.navigationController.viewControllers.append(photosViewController)
    }
}

extension PhotosCoordinator: PhotosViewControllerCoordinatorDelegate {
//    func navigateToNextPage() {
//        let someViewController: ViewController = ViewController()
//        someViewController.coordinator = self
//        self.navigationController.viewControllers.append(someViewController)
//    }
//
    func navigateToPreviousPage() {
        self.delegate?.navigateToPreviousPage(newOrderCoordinator: self)
    }
}
