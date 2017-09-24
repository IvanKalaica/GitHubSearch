//
//  GitHubConstants.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation

struct GitHubOAuth {
    static let clientId = "09f9a7a3705b7a45c06a"
    static let clientSecret = "82f89a38d90deb3b8c9622566c432f8ec1b86a07"
    static let authorizeUri = "https://github.com/login/oauth/authorize"
    static let tokenUri = "https://github.com/login/oauth/access_token"
    static let redirectUris = ["githubsearch://oauth/callback"]
    static let scope = "user repo:status"
    static let secretInBody = true
    static let keychain = true
}

enum GitHub {
    case repoSearch(query: String, sort: RepositorySort)
    case repo(name: String, username: String)
    case user(username: String)
    case authenticatedUser
    case smallAvatar(username: String)
    case webRepository(name: String, username: String)
    case webUser(username: String)
    
    private struct BaseURL {
        static let api = "https://api.github.com"
        static let web = "https://github.com"
        static let avatars = "https://avatars.githubusercontent.com"
    }
    
    var url: String {
        switch self {
        case .repoSearch(let query, let sort):
            return BaseURL.api + "/search/repositories?q=\(query)&sort=\(sort.stringValue)"
        case .repo(let name, let username):
            return BaseURL.api + "/repos/\(username)/\(name)"
        case .authenticatedUser:
            return BaseURL.api + "/user"
        case .user(let username):
            return BaseURL.api + "/users/\(username)"
        case .smallAvatar(let username):
            return BaseURL.avatars + "/\(username)?size=120"
        case .webRepository(let name, let username):
            return BaseURL.web + "/\(username)/\(name)"
        case .webUser(let username):
            return BaseURL.web + "/\(username)"
        }
    }
}

fileprivate extension RepositorySort {
    var stringValue: String {
        switch self {
        case .stars:
            return "stars"
        case .forks:
            return "forks"
        case .updated:
            return "updated"
        }
    }
}
