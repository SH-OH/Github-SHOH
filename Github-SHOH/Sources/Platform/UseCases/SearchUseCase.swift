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
    var currentKeyword: String?
    
    init(isStub: Bool = false) {
        self.provider = Self.initProvider(isStub)
    }
    
    func fetchSearchUsers(
        query: String?,
        page: Int,
        perPage: Int = 20,
        sort: SearchService.SortType = .joined
    ) -> Observable<(model: SearchUsersModel, nextPage: Int)> {
        
        self.currentKeyword = query
        
        guard let query = query, !query.isEmpty else {
            return .just((SearchUsersModel.defaultValue, 1))
        }
        
        return self.request(
            SearchUsersModel.self,
            target: .searchUsers(
                query: query,
                perPage: perPage,
                page: page,
                sort: sort
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
