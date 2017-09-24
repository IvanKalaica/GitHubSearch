//
//  GitHubSearchTests.swift
//  GitHubSearchTests
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import XCTest
import RxSwift
@testable import GitHubSearch

fileprivate let ExpectationTimeout = 5.0

class GitHubSearchTests: XCTestCase {
    func testDefaultRepositoryServiceSearch() {
        let expectation = self.expectation(description: "default repository sevice search test")
        let networkService = DefaultNetworkService()
        _ = DefaultGitHubService(
            repositoryService: DefaultGitHubRepositoryService(networkService: networkService),
            userService: DefaultGitHubUserService(networkService: networkService)
            )
            .repository(query: "rx", sort: .stars)
            .debug()
            .subscribe(onNext: { (repoSearchResult: RepositorySearchResult) in
                XCTAssertNotNil(repoSearchResult)
                XCTAssertEqual(repoSearchResult.items.first!.name, "RxJava")
                expectation.fulfill()
            }, onError: { (error: Error) in
                XCTFail()
                expectation.fulfill()
            })
        self.wait(for: [expectation], timeout: ExpectationTimeout)
    }
    
    func testDefaultUserServiceUserFetch() {
        let username = "IvanKalaica"
        let expectation = self.expectation(description: "default user sevice fetch user test")
        let networkService = DefaultNetworkService()
        _ = DefaultGitHubService(
            repositoryService: DefaultGitHubRepositoryService(networkService: networkService),
            userService: DefaultGitHubUserService(networkService: networkService)
            )
            .user(username: username)
            .debug()
            .subscribe(onNext: { (user: User) in
                XCTAssertNotNil(user)
                XCTAssertEqual(user.username, username)
                expectation.fulfill()
            }, onError: { (error: Error) in
                XCTFail()
                expectation.fulfill()
            })
        self.wait(for: [expectation], timeout: ExpectationTimeout)
    }
}
