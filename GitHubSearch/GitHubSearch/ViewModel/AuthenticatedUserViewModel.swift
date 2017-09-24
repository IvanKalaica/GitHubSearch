//
//  AuthenticatedUserViewModel.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 24/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation

protocol AuthenticatedUserViewModel {
    var avatarUrl: String { get }
    var username: String { get }
    var name: TitleValuePair { get }
    var createdAt: TitleValuePair { get }
    var company: TitleValuePair { get }
    var email: TitleValuePair { get }
}

struct DefaultAuthenticatedUserViewModel: AuthenticatedUserViewModel {
    let avatarUrl: String
    let username: String
    let name: TitleValuePair
    let createdAt: TitleValuePair
    let company: TitleValuePair
    let email: TitleValuePair
    
    init(user: User) {
        self.avatarUrl = user.avatarUrl
        self.username = user.username
        self.name = TitleValuePair(title: NSLocalizedString("Name", comment: "User profile details name label"), value: user.name)
        self.createdAt = TitleValuePair(title: NSLocalizedString("Created", comment: "User profile details created at label"), value: user.createdAt?.string())
        self.company = TitleValuePair(title: NSLocalizedString("Company", comment: "User profile details company label"), value: user.company)
        self.email = TitleValuePair(title: NSLocalizedString("Email", comment: "User profile details email label"), value: user.email)
    }
}
