//
//  DefaultNetworkService.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import RxSwift
import Alamofire

protocol Decodable {
    init(data: Any) throws
}

enum NetworkMethod {
    case get, post, put, delete
}

protocol NetworkService {
    func request<D: Decodable>(method: NetworkMethod, url: String, parameters: [String : Any]?, type: D.Type) -> Observable<D>
    func request(method: NetworkMethod, url: String, parameters: [String : Any]?) -> Observable<Any>
}

final class DefaultNetworkService: NetworkService {
    private let queue = DispatchQueue(label: "GitHubSearch.DefaultNetworkService.Queue")
    
    func request<D: Decodable>(method: NetworkMethod, url: String, parameters: [String : Any]?, type: D.Type) -> Observable<D> {
        return request(method: method, url: url, parameters: parameters)
            .map {
                do {
                    return try D(data: $0)
                } catch {
                    throw NetworkError.IncorrectDataReturned
                }
        }
    }
    
    func request(method: NetworkMethod, url: String, parameters: [String : Any]?) -> Observable<Any> {
        return Observable.create { observer in
            let method = method.httpMethod()
            
            let request = Alamofire.request(url, method: method, parameters: parameters)
                .validate()
                .responseJSON(queue: self.queue) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(NetworkError(error: error))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

fileprivate extension NetworkMethod {
    func httpMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
}
