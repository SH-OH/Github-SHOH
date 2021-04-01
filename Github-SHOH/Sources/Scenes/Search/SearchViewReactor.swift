//
//  SearchViewReactor.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import ReactorKit

final class SearchViewReactor: Reactor {
    struct Page {
        var nextPage: Int
        var isFail: Bool
        
        mutating func updateNextPage(_ nextPage: Int) -> Page {
            self.nextPage = nextPage
            self.isFail = false
            return self
        }
        
        mutating func updateIsFail(_ isFail: Bool) -> Page {
            self.isFail = isFail
            return self
        }
    }
    
    enum Action {
        case enteredSearchText(String?)
        case updatedUserList([UserModel])
        case didPrefetchNextPage(Page)
    }
    
    enum Mutation {
        case updateUserList(([UserModel], Page, Bool))
        case updateSections([SearchSection])
    }
    
    struct State {
        var userList: [UserModel]
        var sections: [SearchSection]
        var nextPage: Page
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(_ useCase: SearchUseCase) {
        self.initialState = .init(
            userList: [],
            sections: [],
            nextPage: Page(nextPage: 1, isFail: false)
        )
        self.useCase = useCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .enteredSearchText(enteredKeyword):
            let fetchList = self.useCase
                .fetchSearchUsers(
                    query: enteredKeyword,
                    page: 1
                )
                .map { ($0.model.items, Page(nextPage: $0.nextPage, isFail: false)) }
                .map { Mutation.updateUserList(($0.0, $0.1, true)) }
            
            return fetchList
        case let .updatedUserList(userList):
            let updateSections: Observable<Mutation> = Observable.just(userList)
                .flatMapLatest({ (_userList) -> Observable<[SearchSectionItem]> in
                    return Observable.from(_userList)
                        .map { SearchSectionItem.user(SearchCellReactor($0)) }
                        .toArray()
                        .asObservable()
                })
                .map { SearchSection.section(items: $0) }
                .map { Mutation.updateSections([$0]) }
            
            return updateSections
        case var .didPrefetchNextPage(nextPage):
            var updatedNextPage = nextPage.updateIsFail(false)
            
            let prefetchList = self.useCase
                .fetchSearchUsers(
                    query: self.useCase.currentKeyword,
                    page: updatedNextPage.nextPage
                )
                .map { ($0.model.items, updatedNextPage.updateNextPage($0.nextPage)) }
                .map { Mutation.updateUserList(($0.0, $0.1, false)) }
                .catchAndReturn(
                    Mutation.updateUserList(
                        ([], updatedNextPage.updateIsFail(true), false)
                    )
                )
            
            return prefetchList
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state
        switch mutation {
        case let .updateUserList((userList, nextPage, isNew)):
            if isNew {
                newState.userList = userList
            } else {
                newState.userList.append(contentsOf: userList)
            }
            newState.nextPage = nextPage
        case let .updateSections(sections):
            newState.sections = sections
        }
        return newState
    }
    
}

// MARK: - Filter

extension SearchViewReactor.Page {
    static func distinctWithFailure(_ lhs: Self, _ rhs: Self) -> Bool {
        if rhs.isFail {
            return false
        }
        return lhs.nextPage == rhs.nextPage
    }
}
