//
//  UsersUseCaseTests.swift
//  Github-SHOHTests
//
//  Created by Oh Sangho on 2021/04/02.
//

import XCTest
@testable import Github_SHOH
import RxExpect
import RxTest
import RxSwift

class UsersUseCaseTests: XCTestCase {
    
    var useCase: UsersUseCase!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        useCase = UsersUseCase(isStub: true)
        disposeBag = .init()
    }

    override func tearDownWithError() throws {
        disposeBag = .init()
    }
    
    func test_유저_데이터_가져오기_API_검증() {
        let userName: String = "JINSEOBJEON"
        useCase
            .fetchGetUser(userName: userName)
            .subscribe { (user) in
                XCTAssertEqual(user.login, userName)
            } onError: { (error) in
                print("\(#function) error : \(error)")
            }.disposed(by: disposeBag)
    }
}
