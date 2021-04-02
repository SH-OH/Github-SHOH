//
//  UserModel.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import Foundation

struct UserModel: Decodable {
    let login: String
    let id: Int
    let avatarUrl: String
    let url: String
    let type: String
    let publicRepos: Int?
}

extension UserModel: Equatable {}
