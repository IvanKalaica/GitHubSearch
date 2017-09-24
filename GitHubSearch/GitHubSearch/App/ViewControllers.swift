//
//  ViewControllers.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import UIKit

enum Screen {
    case repositorySearch
    case repository(RepositoryViewModel)
    case user(UserViewModel)
    case myProfile
}

protocol ViewControllers {
    func get(_ screen: Screen) -> UIViewController
}

struct DefaultViewControllers: ViewControllers {
    private let viewModels: ViewModels
    
    init(viewModels: ViewModels) {
        self.viewModels = viewModels
    }
    
    func get(_ screen: Screen) -> UIViewController {
        switch screen {
        case .repositorySearch:
            let vc = RepositorySearchViewController(toolbox: Toolbox(viewControllers: self), viewModel: self.viewModels.repositorySearchViewModel)
            vc.title = NSLocalizedString("Repositories", comment: "Main screen \"Repositories\" section nav and tab bar title")
            return vc
        case .repository(let viewModel):
            return RepositoryViewController(toolbox: Toolbox(viewControllers: self), viewModel: viewModel)
        case .user(let viewModel):
            return UserViewController(viewModel: viewModel)
        case .myProfile:
            let vc = MyProfileViewController(viewModel: self.viewModels.myProfileViewModel)
            vc.title = NSLocalizedString("My Profile", comment: "Main screen \"My Profile\" section nav and tab bar title")
            return vc
        }
    }
}
