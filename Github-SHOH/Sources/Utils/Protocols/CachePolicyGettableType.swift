//
//  CachePolicyGettableType.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import Moya

protocol CachePolicyGettableType {
    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}

final class CachePolicyPlugin: PluginType {
    func prepare(
        _ request: URLRequest,
        target: TargetType
    ) -> URLRequest {
        guard let policyGettable = target as? CachePolicyGettableType else {
            return request
        }
        var newRequest = request
        newRequest.cachePolicy = policyGettable.cachePolicy
        
        return newRequest
    }
}
