//
//  SearchSection.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import RxDataSources

enum SearchSection {
    case section(items: [SearchSectionItem])
}

enum SearchSectionItem {
    case user(SearchCellReactor)
}

extension SearchSection: SectionModelType {
    var items: [SearchSectionItem] {
        switch self {
        case let .section(items):
            return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .section:
            self = .section(items: items)
        }
    }
}

extension SearchSection: Hashable {
    static func == (lhs: SearchSection, rhs: SearchSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension SearchSectionItem: Hashable {
    static func == (lhs: SearchSectionItem, rhs: SearchSectionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .user(let reactor):
            hasher.combine(reactor.currentState.loginId)
        }
    }
}
