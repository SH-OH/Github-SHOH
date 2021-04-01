//
//  Coordinator.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import UIKit.UINavigationController

protocol Coordinator: class {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
