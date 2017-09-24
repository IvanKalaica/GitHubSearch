//
//  RepositorySearchViewModel.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RepositorySearchViewModel {
    // MARK: - Input
    var searchText: PublishSubject<String> { get }
    var sort: PublishSubject<Int> { get }
    var repositoryDidSelect: PublishSubject<Int> { get }
    var userDidSelect: PublishSubject<Int> { get }
    
    // MARK: - Output
    var cellViewModels: Observable<[RepositorySearchCellViewModel]> { get }
    var presentRepository: Driver<RepositoryViewModel> { get }
    var presentUser: Driver<UserViewModel> { get }
}

struct DefaultRepositorySearchViewModel: RepositorySearchViewModel {
    let searchText: PublishSubject<String> = PublishSubject<String>()
    let sort: PublishSubject<Int> = PublishSubject<Int>()
    let repositoryDidSelect: PublishSubject<Int> = PublishSubject<Int>()
    let userDidSelect: PublishSubject<Int> = PublishSubject<Int>()
    
    let cellViewModels: Observable<[RepositorySearchCellViewModel]>
    let presentRepository: Driver<RepositoryViewModel>
    let presentUser: Driver<UserViewModel>
    
    init(gitHubService: GitHubService, viewModels: ViewModels) {
        let cellViewModels = Observable.combineLatest(
            self.searchText.debounce(0.3, scheduler: MainScheduler.instance).distinctUntilChanged(),
            self.sort.startWith(0).distinctUntilChanged()
            )
            .flatMapLatest { gitHubService.repository(query: $0, sort: RepositorySort.from(scope: $1)).catchErrorJustReturn(RepositorySearchResult()) }
            .observeOn(MainScheduler.instance)
            .map { $0.items }
            .shareReplay(1)
        
        self.cellViewModels = cellViewModels.map { $0.map { viewModels.repositorySearchCellViewModel(repository: $0)} }
        
        self.presentRepository = self.repositoryDidSelect
            .withLatestFrom(cellViewModels, resultSelector: { $1[$0] })
            .map { viewModels.repositoryViewModel(repository: $0) }
            .asDriverIgnoringErrors()
        
        self.presentUser = self.userDidSelect
            .withLatestFrom(cellViewModels, resultSelector: { $1[$0].owner })
            .map { viewModels.userViewModel(user: $0) }
            .asDriverIgnoringErrors()
    }
}

fileprivate extension RepositorySort {
    static func from(scope: Int) -> RepositorySort {
        switch scope {
        case 0:
            return .stars
        case 1:
            return .forks
        default:
            return .updated
        }
    }
}
