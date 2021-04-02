//
//  SearchCoordinator.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    private weak var navigationController: BaseNavigationController?
    
    init(_ navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchVC = SearchViewController.storyboard()
        let searchUseCase: SearchUseCase = .init()
        let usersUseCase: UsersUseCase = .init()
        searchVC.reactor = SearchViewReactor(
            searchUseCase: searchUseCase,
            usersUseCase: usersUseCase
        )
        navigationController?.pushViewController(
            searchVC,
            animated: false
        )
    }
}
