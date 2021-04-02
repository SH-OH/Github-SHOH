//
//  SearchCellReactorTests.swift
//  Github-SHOHTests
//
//  Created by Oh Sangho on 2021/04/02.
//

import XCTest
@testable import Github_SHOH
import RxExpect
import RxTest
import RxSwift

class SearchCellReactorTests: XCTestCase {
    
    func test_유저_데이터_가져와서_레포지토리_개수_뽑아내기_검증() {
        let samepleData = SearchService.getSampleData("SearchUsers_2")
        let testUser: UserModel = try! SearchUsersModel.decode(data: samepleData).items.first!
        
        let test = RxExpect()
        let usersUseCase = UsersUseCase(isStub: true)
        let reactor = test.retain(SearchCellReactor(
            testUser, usersUseCase: usersUseCase
        ))
        
        test.input(reactor.action, [
            Recorded.next(100, .didFetchGetUser("JINSEOBJEON"))
        ])
        
        let numberOfRepos = reactor.state.map { $0.numberOfRepos }
        
        test.assert(numberOfRepos) { (events) in
            XCTAssertEqual(events, [
                Recorded.next(0, nil),
                Recorded.next(100, 2)
            ])
        }
    }
    
}
