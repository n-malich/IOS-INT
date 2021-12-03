//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class FeedCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
   
    let navigationController: UINavigationController
    
    var childCoordinators = [CoordinatorProtocol]()
    
    required init() {
        self.navigationController = .init()
    }
    
    func openFeedViewController() {
        let feedViewController: FeedViewController = FeedViewController()
        feedViewController.navigationItem.title = "Feed"
        feedViewController.coordinator = self
        self.navigationController.viewControllers = [feedViewController]
    }
}

extension FeedCoordinator: FeedViewControllerCoordinatorDelegate {
    func navigateToNextPage() {
        let postCoordinator = PostCoordinator(navigationController: navigationController)
        postCoordinator.delegate = self
        childCoordinators.append(postCoordinator)
        postCoordinator.openPostViewControler()
    }
}

extension FeedCoordinator: BackToFeedViewControllerCoordinatorDelegate {
    func navigateToPreviousPage(newOrderCoordinator: PostCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
