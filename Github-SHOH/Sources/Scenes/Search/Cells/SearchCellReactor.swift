//
//  SearchCellReactor.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import ReactorKit

final class SearchCellReactor: Reactor {
    enum Action {
        case didFetchGetUser(String)
    }
    
    enum Mutation {
        case updateNumberOfRepos(Int?)
    }
    
    struct State {
        var avatarUrl: String
        var loginId: String
        var numberOfRepos: Int?
    }
    
    let initialState: State
    
    private let usersUseCase: UsersUseCase
    
    init(
        _ user: UserModel,
        usersUseCase: UsersUseCase
    ) {
        self.initialState = .init(
            avatarUrl: user.avatarUrl,
            loginId: user.login
        )
        self.usersUseCase = usersUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didFetchGetUser(loginId):
            let updateNumberOfRepos: Observable<Mutation> = self.usersUseCase
                .fetchGetUser(userName: loginId)
                .map { $0.publicRepos }
                .map { Mutation.updateNumberOfRepos($0) }
            
            return updateNumberOfRepos
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state
        switch mutation {
        case let .updateNumberOfRepos(numberOfRepos):
            newState.numberOfRepos = numberOfRepos
            return newState
        }
    }
}
