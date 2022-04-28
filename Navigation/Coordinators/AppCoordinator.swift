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

        let feedItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 0)
        let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        let favoritePostsItem = UITabBarItem(title: "Favorite posts", image: UIImage(systemName: "star.fill"), tag: 3)

        let feedCoordinator = FeedCoordinator()
        feedCoordinator.parentCoordinator = self
        feedCoordinator.openFeedViewController()
        let feedViewController = feedCoordinator.navigationController
        feedViewController.tabBarItem = feedItem
       
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.parentCoordinator = self
        loginCoordinator.openLoginViewController()
        let loginViewController = loginCoordinator.navigationController
        loginViewController.tabBarItem = profileItem
        
        let favoritePostsCoordinator = FavoritePostsCoordinator()
        favoritePostsCoordinator.parentCoordinator =  self
        favoritePostsCoordinator.openFavoritePostsViewController()
        let favoritePostsViewController = favoritePostsCoordinator.navigationController
        favoritePostsViewController.tabBarItem = favoritePostsItem
        
        

        tabBarController.viewControllers = [feedViewController,loginViewController, favoritePostsViewController]

        return tabBarController
    }
}
