//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var childCoordinators = [CoordinatorProtocol]()
    
    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }

    func start() {
        let tabBarController = self.setTabBarController()
        self.window?.rootViewController = tabBarController
    }

    func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let firstItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), tag: 0)
        let secondItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)


        let firstCoordinator = FeedCoordinator()
        firstCoordinator.parentCoordinator = self
        firstCoordinator.openFeedViewController()
        let firstViewController = firstCoordinator.navigationController
        firstViewController.tabBarItem = firstItem
       
        let secondCoordinator = LoginCoordinator()
        secondCoordinator.parentCoordinator = self
        secondCoordinator.openLoginViewController()
        let secondViewControllerVC = secondCoordinator.navigationController
        secondViewControllerVC.tabBarItem = secondItem

        tabBarController.viewControllers = [firstViewController,secondViewControllerVC]

        return tabBarController
    }
}
