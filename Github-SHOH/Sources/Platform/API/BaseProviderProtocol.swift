//
//  BaseProviderProtocol.swift
//  Github-SHOH
//
//  Created by Oh Sangho on 2021/04/01.
//

import Foundation
import Moya
import RxSwift
import SPMSHOHProxy

protocol BaseProviderProtocol: class {
    associatedtype Target: TargetType
    
    var provider: MoyaProvider<Target> { get set }
    
    init(isStub: Bool)
}

extension BaseProviderProtocol {
    static func initProvider(_ isStub: Bool) -> MoyaProvider<Target> {
        if !isStub {
            return MoyaProvider<Target>()
        } else {
            return MoyaProvider<Target>(stubClosure: MoyaProvider.immediatelyStub)
        }
    }
    
    func request<T: Decodable>(
        _ modelType: T.Type,
        target: Target
    ) -> Single<(model: T, link: [String: String]?)> {
        return self.provider.rx
            .request(target)
            .do { (res) in
                let makeDict: [String: Any] = [
                    "01.URL": "[\(target.method.rawValue)] \(target.baseURL)\(target.path)",
                    "02.Target": target,
                    "03.Response": String(data: res.data, encoding: .utf8) ?? "NO DATA"
                ]
//                print(makeDict)
            }
            .flatMap({ (res) -> Single<(model: T, link: [String: String]?)> in
                if 200...399 ~= res.statusCode {
                    let model = try modelType.decode(data: res.data)
                    let link = res.response?.link
                    return .just((model, link))
                } else {
                    let errorModel = try APIErrorModel.decode(data: res.data)
                    return .error(errorModel)
                }
            })
            .catch { (error) -> PrimitiveSequence<SingleTrait, (model: T, link: [String: String]?)> in
                print("Request Error : \(error)")
                return .error(error)
            }
    }
}

// MARK: - Link Header

extension HTTPURLResponse {
    fileprivate var link: [String: String] {
        guard let linkHeader = self.allHeaderFields["Link"] as? String else {
            return [:]
        }
        return parseLink(linkHeader: linkHeader)
    }
    
    private func parseLink(linkHeader: String) -> [String: String] {
        var linkDic: [String: String] = [:]
        
        let splitLink = linkHeader.components(separatedBy: ", ")
        
        splitLink.enumerated().forEach { (index, _linkValue) in
            var urlValue: String = ""
            var relValue: String = ""
            
            let linkValue = _linkValue.components(separatedBy: "; ")
            
            if let url = linkValue.first, url.hasPrefix("<") && url.hasSuffix(">") {
                let s: String.Index = url.index(after: url.startIndex)
                let e: String.Index = url.index(before: url.endIndex)
                urlValue = String(url[s..<e])
            }
            
            if let rel = linkValue.last {
                if let _s = rel.firstIndex(of: "\""),
                   let e = rel.lastIndex(of: "\"") {
                    let s = rel.index(after: _s)
                    relValue = String(rel[s..<e])
                }
            }
            
            linkDic[relValue] = urlValue
        }
        
        return linkDic
    }
}
