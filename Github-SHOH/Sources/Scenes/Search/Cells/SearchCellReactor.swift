//
//  SearchCellReactor.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import ReactorKit

final class SearchCellReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var avatarUrl: String
        var loginId: String
    }
    
    let initialState: State
    
    init(_ user: UserModel) {
        self.initialState = .init(
            avatarUrl: user.avatarUrl,
            loginId: user.login
        )
    }
}
