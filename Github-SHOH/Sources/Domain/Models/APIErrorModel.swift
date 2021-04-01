//
//  APIErrorModel.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import Foundation

struct APIErrorModel: Decodable, Error {
    let message: String
    let errors: [APIError]?
    let documentationUrl: String
}

struct APIError: Decodable {
    let resource: String
    let field: String
    let code: String
}
