//
//  MyProfileViewModel.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 24/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFeedback

enum State {
    case loggedIn(AuthenticatedUserViewModel)
    case loggedOut
    case authorizing
    
    var buttonTitle: String? {
        switch self {
        case .loggedIn:
            return NSLocalizedString("Logout", comment: "My profile logout button title")
        case .loggedOut:
            return NSLocalizedString("Login", comment: "My profile login button title")
        case .authorizing:
            return ""
        }
    }
    fileprivate typealias FeedbackLoop = (Driver<State>) -> Signal<Event>
}

fileprivate enum Event {
    case newData(AuthenticatedUserViewModel)
    case logOut
    case login
}

fileprivate extension State {
    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .newData(let data):
            return .loggedIn(data)
        case .logOut:
            return .loggedOut
        case .login:
            return .authorizing
        }
    }
}

fileprivate func system(
    initialState: State,
    oAuthService: OAuthService,
    gitHubService: GitHubService,
    viewModels: ViewModels,
    toggleUser: Driver<()>
    ) -> Driver<State> {
    
    let currentUser = gitHubService
        .authenticatedUser()
        .map { Event.newData(viewModels.authenticatedUserViewModel(user: $0)) }
    
    let dataFeedbackLoop: State.FeedbackLoop = { state in
        return currentUser.asSignalIgnoringErrors()
    }
    
    let toggleUserFeedbackLoop: State.FeedbackLoop = { state in
        return toggleUser
            .withLatestFrom(state)
            .flatMapLatest { state in
                switch state {
                case .loggedIn:
                    oAuthService.logout()
                    return Signal.just(Event.logOut)
                case .loggedOut:
                    return currentUser.asSignalIgnoringErrors()
                case .authorizing:
                    return Signal.empty()
                }
        }
    }
    return Driver<Any>.system(initialState: initialState,
                              reduce: State.reduce,
                              feedback: dataFeedbackLoop, toggleUserFeedbackLoop)
}

protocol MyProfileViewModel {
    var state: Driver<State> { get }
    var toggleUser: PublishSubject<Void> { get }
}

struct DefaultMyProfileViewModel: MyProfileViewModel {
    let toggleUser: PublishSubject<Void> = PublishSubject<Void>()
    let state: Driver<State>
    
    init(oAuthService: OAuthService, gitHubService: GitHubService, viewModels: ViewModels) {
        self.state = system(
            initialState: .authorizing,
            oAuthService: oAuthService,
            gitHubService: gitHubService,
            viewModels: viewModels,
            toggleUser: self.toggleUser.asDriverIgnoringErrors()
        )
    }
}
