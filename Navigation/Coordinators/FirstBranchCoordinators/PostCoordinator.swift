//
//  PostCoordinator.swift
//  Navigation
//
//  Created by Natali Malich on 18.11.2021.
//

import UIKit

protocol BackToFeedViewControllerCoordinatorDelegate: AnyObject {
    func navigateToPreviousPage(newOrderCoordinator: PostCoordinator)
}

class PostCoordinator: CoordinatorProtocol {
    
    weak var delegate: BackToFeedViewControllerCoordinatorDelegate?
    var childCoordinators = [CoordinatorProtocol]()
    unowned let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openPostViewControler() {
        let postViewController: PostViewController = PostViewController()
        postViewController.navigationItem.title = postViewController.post.title
        postViewController.coordinator = self
        self.navigationController.pushViewController(postViewController, animated: true)
    }
}

extension PostCoordinator: PostViewControllerCoordinatorDelegate {
    func navigateToNextPage() {
        let infoCoordinator: InfoCoordinator = InfoCoordinator(navigationController: navigationController)
        infoCoordinator.delegate = self
        childCoordinators.append(infoCoordinator)
        infoCoordinator.openInfoViewController()
    }
}

extension PostCoordinator: BackToPostViewControllerCoordinatorDelegate {
    func navigateToPreviousPage(newOrderCoordinator: InfoCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
