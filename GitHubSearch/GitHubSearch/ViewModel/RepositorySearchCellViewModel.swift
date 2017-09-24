//
//  RepositorySearchCellViewModel.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation

protocol RepositorySearchCellViewModel {
    var title: String { get }
    var subtitle: String { get }
    var avatarUrl: String { get }
}

struct DefaultRepositorySearchCellViewModel: RepositorySearchCellViewModel {
    let title: String
    let subtitle: String
    let avatarUrl: String
    
    init(repository: Repository) {
        self.title = repository.name
        self.subtitle = repository.owner.username
            + ", \(NSLocalizedString("watchers", comment: "Repository search cell watchers count title")): \(repository.watchersCount)"
            + ", \(NSLocalizedString("forks", comment: "Repository search cell watchers count title")): \(repository.forksCount)"
            + ", \(NSLocalizedString("issues", comment: "Repository search cell watchers count title")): \(repository.openIssuesCount)"
        self.avatarUrl = GitHub.smallAvatar(username: repository.owner.username).url
    }
}
