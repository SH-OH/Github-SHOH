//
//  URL+Extensions.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import Foundation

extension URL {
    var page: Int {
        guard let urlComp = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let items = urlComp.queryItems else {
            return 1
        }
        
        let page: String = items.first(where: { $0.name == "page" })?.value ?? "1"
        
        return Int(page) ?? 1
    }
}
