//
//  ObservableType+Extensions.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnEmpty() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
}
