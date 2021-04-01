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
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let receivedEventsUrl: String
    let type: String
    let score: Int
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let eventsUrl: String
    let siteAdmin: Bool
}
