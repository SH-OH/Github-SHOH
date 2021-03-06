//
//  BaseService.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import Foundation

protocol BaseService {}

extension BaseService {
    private static var baseURLString: String {
        return "https://api.github.com"
    }
    private static var GITHUB_API_TOKEN: String {
        return "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"
    }
}

extension BaseService {
    var baseURL: URL {
        return URL(string: Self.baseURLString)!
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = "token \(Self.GITHUB_API_TOKEN)"
        headers["accept"] = "application/vnd.github.v3+json"
        return headers
    }
    
    static func getSampleData(_ resource: String) -> Data {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            return Data()
        }
        return (try? Data(contentsOf: url)) ?? Data()
    }
}
