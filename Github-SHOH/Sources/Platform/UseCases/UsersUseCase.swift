//
//  UsersUseCase.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/02.
//

import RxSwift
import Moya

final class UsersUseCase: BaseProviderProtocol {
    
    var provider: MoyaProvider<UsersService>
    
    init(isStub: Bool = false) {
        self.provider = Self.initProvider(isStub, useCache: true)
    }
    
    func fetchGetUser(userName: String) -> Observable<UserModel> {
        return self.request(
            UserModel.self,
            target: .getUser(userName: userName)
        )
        .asObservable()
        .map { $0.model }
    }
}
