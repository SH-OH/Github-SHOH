//
//  SearchUseCase.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import RxSwift
import Moya

final class SearchUseCase: BaseProviderProtocol {
    
    var provider: MoyaProvider<SearchService>
    
    init(isStub: Bool = false) {
        self.provider = Self.initProvider(isStub)
    }
    
    func fetchSearchUsers(
        query: String?,
        perPage: Int = 20,
        page: Int
    ) -> Observable<(model: SearchUsersModel, nextPage: Int)> {
        guard let query = query, !query.isEmpty else {
            return .just((SearchUsersModel.defaultValue, 1))
        }
        
        return self.request(
            SearchUsersModel.self,
            target: .searchUsers(
                query: query,
                perPage: perPage,
                page: page
            )
        )
        .asObservable()
        .map({ (model, link) -> (model: SearchUsersModel, nextPage: Int) in
            if let nextUrl = link?["next"], let url = URL(string: nextUrl) {
                return (model, url.page)
            }
            return (model, 1)
        })
    }
}
