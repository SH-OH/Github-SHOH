//
//  SearchService.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import Moya

enum SearchService {
    enum SortType: String {
        case followers, repositories, joined
    }
    
    enum OrderType: String {
        case asc, desc
    }
    
    case searchUsers(
            query: String,
            perPage: Int,
            page: Int,
            sort: SortType?
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
        case let .searchUsers(query, perPage, page, sort):
            params["q"] = query
            params["per_page"] = perPage
            params["page"] = page
            params["sort"] = sort?.rawValue
        }
        return .requestParameters(
            parameters: params,
            encoding: URLEncoding.default
        )
    }
    
    var sampleData: Data {
        switch self {
        case .searchUsers(_, _, let page, _):
            return Self.getSampleData("SearchUsers_\(page)")
        }
    }
}
