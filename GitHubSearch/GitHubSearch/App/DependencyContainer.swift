//
//  DependencyContainer.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation

struct DependencyContainer {
    let services: Services
    var viewControllers: ViewControllers {
        return DefaultViewControllers(viewModels: DefaultViewModels(gitHubService: self.services.gitHubService, oAuthService: self.services.oAuthService))
    }
    init() {
        self.services = DefaultServices()
    }
}
