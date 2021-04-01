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
        let useCase: SearchUseCase = .init()
        searchVC.reactor = SearchViewReactor(useCase)
        navigationController?.pushViewController(
            searchVC,
            animated: false
        )
    }
}
