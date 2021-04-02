//
//  SearchViewReactorTests.swift
//  Github-SHOHTests
//
//  Created by Oh Sangho on 2021/04/02.
//

import XCTest
@testable import Github_SHOH
import RxExpect
import RxTest
import RxSwift

class SearchViewReactorTests: XCTestCase {
    
    func test_입력한_단어_검색하기_검증() {
        let test = RxExpect()
        let searchUseCase = SearchUseCase(isStub: true)
        let usersUseCase = UsersUseCase(isStub: true)
        let reactor = test.retain(SearchViewReactor(
            searchUseCase: searchUseCase, usersUseCase: usersUseCase
        ))
        
        test.input(reactor.action, [
            Recorded.next(100, .enteredSearchText("jinseo"))
        ])
        
        let userList = reactor.state.map { $0.userList }
        
        test.assert(userList.map { $0.count }) { (events) in
            XCTAssertEqual(events, [
                Recorded.next(0, 0),
                Recorded.next(100, 20)
            ])
        }
        test.assert(userList.map { $0.first?.login }) { (events) in
            XCTAssertEqual(events, [
                Recorded.next(0, nil),
                Recorded.next(100, "Jinseob98")
            ])
        }
    }
    
    func test_다음페이지_불러오기_검증() {
        let test = RxExpect()
        let searchUseCase = SearchUseCase(isStub: true)
        let usersUseCase = UsersUseCase(isStub: true)
        let reactor = test.retain(SearchViewReactor(
            searchUseCase: searchUseCase, usersUseCase: usersUseCase
        ))
        
        let testNextPage = SearchViewReactor.Page(nextPage: 2, isFail: false)
        
        test.input(reactor.action, [
            Recorded.next(100, .enteredSearchText("jinseo")),
            Recorded.next(200, .didLoadNextPage(testNextPage))
        ])
        
        let userList = reactor.state.map { $0.userList }
        
        test.assert(userList.map { $0.count }) { (events) in
            XCTAssertEqual(events, [
                Recorded.next(0, 0),
                Recorded.next(100, 20),
                Recorded.next(200, 40),
            ])
        }
        test.assert(userList.map { $0.last?.login }) { (events) in
            XCTAssertEqual(events, [
                Recorded.next(0, nil),
                Recorded.next(100, "jinseong730"),
                Recorded.next(200, "jinseop-park")
            ])
        }
    }
    
}
