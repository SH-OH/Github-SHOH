//
//  Reactive+Extensions.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import RxSwift
import RxCocoa
import UIKit
import Kingfisher

extension Reactive where Base: UIImageView {
    func setImage(defaultImage: UIImage? = nil) -> Binder<Resource?> {
        base.kf.cancelDownloadTask()
        
        return Binder(base) { imageView, resource in
            imageView.kf.setImage(with: resource) { (result) in
                switch result {
                case let .success(value):
                    imageView.image = value.image
                case .failure(_):
                    imageView.image = defaultImage
                }
            }
        }
    }
}

extension Reactive where Base: UICollectionView {
    var isScrollToBottom: Observable<Void> {
        return contentOffset
            .flatMapLatest { (offset) -> Observable<Void> in
                let contentHeight = base.contentSize.height
                let height = base.frame.height
                if offset.y > (contentHeight - height) {
                    return .just(())
                }
                return .empty()
            }
    }
}
