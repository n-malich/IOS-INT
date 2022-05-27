//
//  CoordinatorProtocol.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

public protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] {get set}
}
