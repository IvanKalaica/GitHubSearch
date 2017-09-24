//
//  Services.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 24/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation

protocol Services {
    var networkService: NetworkService { get }
    var gitHubService: GitHubService { get }
    var oAuthService: OAuthService { get }
}

struct DefaultServices: Services {
    let networkService: NetworkService
    let gitHubService: GitHubService
    let oAuthService: OAuthService
    init() {
        self.networkService = DefaultNetworkService()
        self.gitHubService = DefaultGitHubService(
            repositoryService: DefaultGitHubRepositoryService(networkService: self.networkService),
            userService: DefaultGitHubUserService(networkService: self.networkService)
        )
        self.oAuthService = DefaultOAuthService()
    }
}
