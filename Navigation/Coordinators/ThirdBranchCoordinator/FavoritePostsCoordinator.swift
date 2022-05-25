//
//  FavoritePostsCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class FavoritePostsCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
    let navigationController: UINavigationController
    var childCoordinators = [CoordinatorProtocol]()
    
    required init() {
        self.navigationController = UINavigationController()
    }
    
    func openFavoritePostsViewController() {
        let favoritePostsViewController: FavoritePostsViewController = FavoritePostsViewController()
        favoritePostsViewController.navigationItem.titleView = favoritePostsViewController.searchBar
//        favoritePostsViewController.coordinator = self
        self.navigationController.viewControllers = [favoritePostsViewController]
    }
}

//extension FavoritePostsCoordinator: FavoritePostsViewControllerCoordinatorDelegate {
//    func navigateToNextPage() {
//        let _coordinator = _Coordinator(navigationController: navigationController)
//        _coordinator.delegate = self
//        childCoordinators.append(_Coordinator)
//        _coordinator.open_ViewController()
//    }
//}
//
//extension FavoritePostsCoordinator: BackTo_ViewControllerDelegate {
//    func navigateToPreviousPage(newOrderCoordinator: _Coordinator) {
//        navigationController.popToRootViewController(animated: false)
//        childCoordinators.removeLast()
//    }
//}
