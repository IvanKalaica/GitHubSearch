//
//  RepositoryViewModel.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RepositoryViewModel {
    var name: Driver<String> { get }
    var language: Driver<TitleValuePair> { get }
    var createdAt: Driver<TitleValuePair> { get }
    var updatedAt: Driver<TitleValuePair> { get }
    var watchersCount: Driver<TitleValuePair> { get }
    var forksCount: Driver<TitleValuePair> { get }
    var openIssuesCount: Driver<TitleValuePair> { get }
    
    var repositoryDidSelect: PublishSubject<Void> { get }
    var userDidSelect: PublishSubject<Void> { get }
    var presentUser: Driver<UserViewModel> { get }
    var presentRepository: Driver<String> { get }
}

struct DefaultRepositoryViewModel: RepositoryViewModel {
    let name: Driver<String>
    let language: Driver<TitleValuePair>
    let createdAt: Driver<TitleValuePair>
    let updatedAt: Driver<TitleValuePair>
    let watchersCount: Driver<TitleValuePair>
    let forksCount: Driver<TitleValuePair>
    let openIssuesCount: Driver<TitleValuePair>
    
    let repositoryDidSelect: PublishSubject<Void> = PublishSubject<Void>()
    let userDidSelect: PublishSubject<Void> = PublishSubject<Void>()
    let presentUser: Driver<UserViewModel>
    var presentRepository: Driver<String>
    
    init(repository: Repository, gitHubService: GitHubService, viewModels: ViewModels) {
        let repo = gitHubService.repository(name: repository.name, username: repository.owner.username).asDriverIgnoringErrors()
        self.name = repo.map { $0.name }
        self.language = repo.map { TitleValuePair(title: NSLocalizedString("Language", comment: "Repository details language label"), value: $0.language) }
        self.createdAt = repo.map { TitleValuePair(title: NSLocalizedString("Created", comment: "Repository details created label"), value: $0.createdAt.string()) }
        self.updatedAt = repo.map { TitleValuePair(title: NSLocalizedString("Updated", comment: "Repository details updated label"), value: $0.updatedAt.string()) }
        self.watchersCount = repo.map { TitleValuePair(title: NSLocalizedString("Watchers Count", comment: "Repository details watchers count label"), value: String($0.watchersCount)) }
        self.forksCount = repo.map { TitleValuePair(title: NSLocalizedString("Forks Count", comment: "Repository details forks count label"), value: String($0.forksCount)) }
        self.openIssuesCount = repo.map { TitleValuePair(title: NSLocalizedString("Open Issues Count", comment: "Repository details open issues count label"), value: String($0.openIssuesCount)) }
        
        self.presentUser = self.userDidSelect
            .map { viewModels.userViewModel(user: repository.owner) }
            .asDriverIgnoringErrors()
        
        self.presentRepository = self.repositoryDidSelect
            .map { GitHub.webRepository(name: repository.name, username: repository.owner.username).url }
            .asDriverIgnoringErrors()
    }
}
