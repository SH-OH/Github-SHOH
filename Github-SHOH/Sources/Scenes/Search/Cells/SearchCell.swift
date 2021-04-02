//
//  SearchCell.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import UIKit.UICollectionViewCell
import ReactorKit

final class SearchCell: UICollectionViewCell {
    
    private struct Constants {
        static let numberOfReposText: String = "Number of repos: "
    }
    
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
        
        reactor.state.map { $0.loginId }
            .distinctUntilChanged()
            .map { Reactor.Action.didFetchGetUser($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.numberOfRepos }
            .distinctUntilChanged()
            .map({ (number) -> String in
                if let number = number {
                    return String(number)
                }
                return "-"
            })
            .map { Constants.numberOfReposText + $0 }
            .bind(to: numberOfReposLabel.rx.text)
            .disposed(by: disposeBag)
            
    }
}
