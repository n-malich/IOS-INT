//
//  InfoCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

protocol BackToPostViewControllerCoordinatorDelegate: AnyObject {
    func navigateToPreviousPage(newOrderCoordinator: InfoCoordinator)
}

class InfoCoordinator: CoordinatorProtocol {
    
    weak var delegate: BackToPostViewControllerCoordinatorDelegate?
    var childCoordinators = [CoordinatorProtocol]()
    unowned let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openInfoViewController() {
        let infoViewController: InfoViewController = InfoViewController()
//        infoViewController.coordinator = self
        self.navigationController.present(infoViewController, animated: true, completion: nil)
    }
}

//extension InfoCoordinator: InfoViewControllerCoordinatorDelegate {
//    func navigateToNextPage() {
//    }
//}

//extension InfoCoordinator: BackToInfoViewControllerCoordinatorDelegate {
//    func navigateToPreviousPage(newOrderCoordinator: SomeCoordinator) {
//        navigationController.popToRootViewController(animated: true)
//        childCoordinators.removeLast()
//    }
//}
