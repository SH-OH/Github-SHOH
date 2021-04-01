//
//  SearchViewReactor.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import ReactorKit

final class SearchViewReactor: Reactor {
    enum Action {
        case enteredSearchText(String?)
        case updatedUserList([UserModel])
    }
    
    enum Mutation {
        case updateUserList(([UserModel], Int))
        case updateSections([SearchSection])
    }
    
    struct State {
        var userList: [UserModel]
        var sections: [SearchSection]
        var nextPage: Int
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(_ useCase: SearchUseCase) {
        self.initialState = .init(
            userList: [],
            sections: [],
            nextPage: 1
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
                .map { Mutation.updateUserList(($0.model.items, $0.nextPage)) }
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state
        switch mutation {
        case let .updateUserList((userList, nextPage)):
            newState.userList = userList
            newState.nextPage = nextPage
        case let .updateSections(sections):
            newState.sections = sections
        }
        return newState
    }
}
