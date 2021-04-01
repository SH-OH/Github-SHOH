//
//  SearchCell.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import UIKit.UICollectionViewCell
import ReactorKit

final class SearchCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag = .init()
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var numberOfReposLabel: UILabel!
    
}

// MARK: - Binding

extension SearchCell: StoryboardView {
    func bind(reactor: SearchCellReactor) {
        reactor.state.map { $0.avatarUrl }
            .distinctUntilChanged()
            .map { URL(string: $0) }
            .bind(to: avatarImageView.rx.setImage())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.loginId }
            .distinctUntilChanged()
            .asDriverOnEmpty()
            .drive(loginLabel.rx.text)
            .disposed(by: disposeBag)   
    }
}
