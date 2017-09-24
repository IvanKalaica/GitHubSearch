//
//  DefaultOAuthService.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 23/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import Alamofire
import OAuth2
import RxSwift

struct DefaultOAuthService: OAuthService {
    private let oAuth2CodeGrant: OAuth2CodeGrant
    init() {
        self.oAuth2CodeGrant = OAuth2CodeGrant(settings: [
            "client_id": GitHubOAuth.clientId,
            "client_secret": GitHubOAuth.clientSecret,
            "authorize_uri": GitHubOAuth.authorizeUri,
            "token_uri": GitHubOAuth.tokenUri,
            "redirect_uris": GitHubOAuth.redirectUris,
            "scope": GitHubOAuth.scope,
            "secret_in_body": GitHubOAuth.secretInBody,
            "keychain": GitHubOAuth.keychain,
            ] as OAuth2JSON)
        
        let sessionManager = SessionManager.default
        let retrier = OAuth2RetryHandler(oauth2: self.oAuth2CodeGrant)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
    }
    
    func authorize() -> Observable<Void> {
        return Observable.create { observer in
            self.oAuth2CodeGrant.authorize() { authParameters, error in
                guard let sError = error else {
                    print("Authorized! Access token is in `oauth2.accessToken`")
                    print("Authorized! Additional parameters: \(String(describing: authParameters))")
                    observer.onNext()
                    observer.onCompleted()
                    return
                }
                print("Authorization was canceled or went wrong: \(String(describing: sError))")
                observer.onError(sError)
            }
            return Disposables.create()
        }
    }
    
    func logout() {
        self.oAuth2CodeGrant.forgetTokens()
        let storage = HTTPCookieStorage.shared
        storage.cookies?.forEach() { storage.deleteCookie($0) }
    }
    
    func handleRedirectURL(_ url: URL) {
        self.oAuth2CodeGrant.handleRedirectURL(url)
    }
}
