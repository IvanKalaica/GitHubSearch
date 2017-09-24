//
//  GitHubRepositoryService.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol GitHubRepositoryService {
    func repository(query: String, sort: RepositorySort) -> Observable<RepositorySearchResult>
    func repository(name: String, username: String) -> Observable<Repository>
}

struct DefaultGitHubRepositoryService: GitHubRepositoryService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func repository(query: String, sort: RepositorySort) -> Observable<RepositorySearchResult> {
        let url = GitHub.repoSearch(query: query, sort: sort).url
        return self.networkService.request(method: .get, url: url, parameters: nil, type: RepositorySearchResult.self)
    }
    
    func repository(name: String, username: String) -> Observable<Repository> {
        let url = GitHub.repo(name: name, username: username).url
        return self.networkService.request(method: .get, url: url, parameters: nil, type: Repository.self)
    }
}
