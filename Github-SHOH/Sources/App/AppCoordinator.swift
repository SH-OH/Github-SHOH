//
//  AppCoordinator.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = BaseNavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let search = SearchCoordinator(navigationController)
        coordinate(to: search)
    }
}
