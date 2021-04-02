//
//  UsersService.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import Moya

enum UsersService {
    case getUser(
            userName: String
         )
}

extension UsersService: BaseService, TargetType {
    var path: String {
        switch self {
        case let .getUser(userName):
            return "/users/\(userName)"
        }
    }
    
    var method: Method {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
        }
    }
}

extension UsersService: CachePolicyGettableType {
    var cachePolicy: MoyaCacheablePolicy {
        switch self {
        case .getUser:
            return .returnCacheDataElseLoad
        }
    }
}
