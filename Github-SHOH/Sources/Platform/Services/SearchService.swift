//
//  SearchService.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import Moya

enum SearchService {
    case searchUsers(
            query: String,
            perPage: Int,
            page: Int
         )
}

extension SearchService: BaseService, TargetType {
    var path: String {
        switch self {
        case .searchUsers:
            return "/search/users"
        }
    }
    
    var method: Method {
        switch self {
        case .searchUsers:
            return .get
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case let .searchUsers(query, perPage, page):
            params["q"] = query
            params["per_page"] = perPage
            params["page"] = page
        }
        return .requestParameters(
            parameters: params,
            encoding: URLEncoding.default
        )
    }
}