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
    }
    
    enum Mutation {
        case updateUserList(([UserModel], Int))
    }
    
    struct State {
        var userList: [UserModel]
        var nextPage: Int
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(_ useCase: SearchUseCase) {
        self.initialState = .init(
            userList: [],
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state
        switch mutation {
        case let .updateUserList((userList, nextPage)):
            newState.userList = userList
            newState.nextPage = nextPage
        }
        return newState
    }
}
