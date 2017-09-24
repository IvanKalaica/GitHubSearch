//
//  ViewModels.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 24/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation

protocol ViewModels {
    var myProfileViewModel: MyProfileViewModel { get }
    var repositorySearchViewModel: RepositorySearchViewModel { get }
    
    func repositorySearchCellViewModel(repository: Repository) -> RepositorySearchCellViewModel
    func repositoryViewModel(repository: Repository) -> RepositoryViewModel
    func userViewModel(user: User) -> UserViewModel
    func authenticatedUserViewModel(user: User) -> AuthenticatedUserViewModel
}

struct DefaultViewModels: ViewModels {
    private let gitHubService: GitHubService
    private let oAuthService: OAuthService
    
    init(gitHubService: GitHubService, oAuthService: OAuthService) {
        self.gitHubService = gitHubService
        self.oAuthService = oAuthService
    }
    
    var myProfileViewModel: MyProfileViewModel {
        return DefaultMyProfileViewModel(oAuthService: self.oAuthService, gitHubService: self.gitHubService, viewModels: self)
    }
    
    var repositorySearchViewModel: RepositorySearchViewModel {
        return DefaultRepositorySearchViewModel(gitHubService: self.gitHubService, viewModels: self)
    }
    
    func repositorySearchCellViewModel(repository: Repository) -> RepositorySearchCellViewModel {
        return DefaultRepositorySearchCellViewModel(repository: repository)
    }
    
    func repositoryViewModel(repository: Repository) -> RepositoryViewModel {
        return DefaultRepositoryViewModel(repository: repository, gitHubService: self.gitHubService, viewModels: self)
    }
    
    func userViewModel(user: User) -> UserViewModel {
        return DefaultUserViewModel(user: user, gitHubService: self.gitHubService)
    }
    
    func authenticatedUserViewModel(user: User) -> AuthenticatedUserViewModel {
        return DefaultAuthenticatedUserViewModel(user: user)
    }
}
