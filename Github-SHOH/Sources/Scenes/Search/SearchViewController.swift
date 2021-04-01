//
//  SearchViewController.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources

final class SearchViewController: BaseViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
}

// MARK: - Binding

extension SearchViewController: StoryboardView {
    func bind(reactor: SearchViewReactor) {
        bindSearchBar(reactor)
        bindCV(reactor)
    }
    
    private func bindSearchBar(_ reactor: SearchViewReactor) {
        searchBar.rx.text.skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { Reactor.Action.enteredSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userList }
            .distinctUntilChanged()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .map { Reactor.Action.updatedUserList($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nextPage }
            .bind { (nextPage) in
                print("nextPage : \(nextPage)")
            }.disposed(by: disposeBag)
    }
    
    private func bindCV(_ reactor: SearchViewReactor) {
        reactor.state.map { $0.sections }
            .bind(to: collectionView.rx.items(dataSource: self.dataSource()))
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension SearchViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SearchSection> {
        return .init { (_, cv, ip, item) -> UICollectionViewCell in
            switch item {
            case .user(let reactor):
                let cell = cv.dequeue(SearchCell.self, for: ip)
                cell.reactor = reactor
                return cell
            }
        }
    }
}
