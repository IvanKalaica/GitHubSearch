//
//  UserViewModel.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserViewModel {
    var avatarUrl: Driver<String> { get }
    var username: Driver<String> { get }
    var name: Driver<TitleValuePair> { get }
    var createdAt: Driver<TitleValuePair> { get }
    var company: Driver<TitleValuePair> { get }
    var email: Driver<TitleValuePair> { get }
    
    var userDidSelect: PublishSubject<Void> { get }
    var presentUser: Driver<String> { get }
}

struct DefaultUserViewModel: UserViewModel {
    let avatarUrl: Driver<String>
    let username: Driver<String>
    let name: Driver<TitleValuePair>
    let createdAt: Driver<TitleValuePair>
    let company: Driver<TitleValuePair>
    let email: Driver<TitleValuePair>
    
    let userDidSelect: PublishSubject<Void> = PublishSubject<Void>()
    var presentUser: Driver<String>
    
    init(user: User, gitHubService: GitHubService) {
        let user = gitHubService
            .user(username: user.username)
            .startWith(user)
            .asDriverIgnoringErrors()
        
        self.avatarUrl = user.map { $0.avatarUrl }
        self.username = user.map { $0.username }
        self.name = user.map { TitleValuePair(title: NSLocalizedString("Name", comment: "User profile details name label"), value: $0.name) }
        self.createdAt = user.map { TitleValuePair(title: NSLocalizedString("Created", comment: "User profile details created at label"), value: $0.createdAt?.string()) }
        self.company = user.map { TitleValuePair(title: NSLocalizedString("Company", comment: "User profile details company label"), value: $0.company) }
        self.email = user.map { TitleValuePair(title: NSLocalizedString("Email", comment: "User profile details email label"), value: $0.email) }
        
        self.presentUser = self.userDidSelect
            .flatMapLatest { user }
            .map { GitHub.webUser(username: $0.username).url }
            .asDriverIgnoringErrors()
    }
}
