//
//  SearchUsersModel.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import Foundation

struct SearchUsersModel: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [UserModel]
}

extension SearchUsersModel {
    static var defaultValue: SearchUsersModel {
        return Self.init(totalCount: 0, incompleteResults: false, items: [])
    }
}
