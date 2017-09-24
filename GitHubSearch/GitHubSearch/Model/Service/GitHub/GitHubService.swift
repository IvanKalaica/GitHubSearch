//
//  GitHubService.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift

enum RepositorySort {
    case stars
    case forks
    case updated
}

protocol GitHubService {
    func repository(query: String, sort: RepositorySort) -> Observable<RepositorySearchResult>
    func repository(name: String, username: String) -> Observable<Repository>
    func user(username: String) -> Observable<User>
    func authenticatedUser() -> Observable<User>
}

struct DefaultGitHubService: GitHubService {
    private let repositoryService: GitHubRepositoryService
    private let userService: GitHubUserService
    
    init(repositoryService: GitHubRepositoryService, userService: GitHubUserService) {
        self.repositoryService = repositoryService
        self.userService = userService
    }
    
    func repository(query: String, sort: RepositorySort) -> Observable<RepositorySearchResult> {
        return self.repositoryService.repository(query: query, sort: sort)
    }
    
    func repository(name: String, username: String) -> Observable<Repository> {
        return self.repositoryService.repository(name: name, username: username)
    }
    
    func user(username: String) -> Observable<User> {
        return self.userService.user(username: username)
    }
    
    func authenticatedUser() -> Observable<User> {
        return self.userService.authenticatedUser()
    }
}
