//
//  SearchViewController.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import UIKit
import ReactorKit
import RxCocoa

final class SearchViewController: BaseViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
}

// MARK: - Binding

extension SearchViewController: StoryboardView {
    func bind(reactor: SearchViewReactor) {
        bindSearchBar(reactor)
    }
    
    private func bindSearchBar(_ reactor: SearchViewReactor) {
        searchBar.rx.text.skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { Reactor.Action.enteredSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userList }
            .bind { (list) in
                print("list.count : \(list.count)")
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.nextPage }
            .bind { (nextPage) in
                print("nextPage : \(nextPage)")
            }.disposed(by: disposeBag)
    }
}
