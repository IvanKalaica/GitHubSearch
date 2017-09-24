//
//  GitHubUserService.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol GitHubUserService {
    func user(username: String) -> Observable<User>
    func authenticatedUser() -> Observable<User>
}

struct DefaultGitHubUserService: GitHubUserService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func user(username: String) -> Observable<User> {
        let url = GitHub.user(username: username).url
        return self.networkService.request(method: .get, url: url, parameters: nil, type: User.self)
    }
    
    func authenticatedUser() -> Observable<User> {
        let url = GitHub.authenticatedUser.url
        return self.networkService.request(method: .get, url: url, parameters: nil, type: User.self)
    }
}
