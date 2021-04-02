//
//  SearchUseCaseTests.swift
//  Github-SHOHTests
//
//  Created by Oh Sangho on 2021/04/02.
//

import XCTest
@testable import Github_SHOH
import RxExpect
import RxTest
import RxSwift

class SearchUseCaseTests: XCTestCase {
    
    var useCase: SearchUseCase!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        useCase = SearchUseCase(isStub: true)
        disposeBag = .init()
    }

    override func tearDownWithError() throws {
        disposeBag = .init()
    }
    
    func test_유저_검색_API_검증() {
        let query: String = "jinseo"
        let page: Int = 1
        useCase
            .fetchSearchUsers(query: query, page: page)
            .subscribe { (model, _) in
                XCTAssertEqual(model.totalCount, 354)
                XCTAssertEqual(model.items.first!.login, "Jinseob98")
            } onError: { (error) in
                print("\(#function) error : \(error)")
            }.disposed(by: disposeBag)
    }
    
}
