//
//  RepositoryViewController.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Eureka

class RepositoryViewController: FormViewController {
    private let toolbox: Toolbox
    private let disposeBag = DisposeBag()
    
    init(toolbox: Toolbox, viewModel: RepositoryViewModel) {
        self.toolbox = toolbox
        super.init(nibName: nil, bundle: nil)
        self.form
            +++ Section()
            <<< LabelRow(Tags.language)
            <<< LabelRow(Tags.createdAt)
            <<< LabelRow(Tags.updatedAt)
            <<< LabelRow(Tags.watchersCount)
            <<< LabelRow(Tags.forksCount)
            <<< LabelRow(Tags.openIssuesCount)
            +++ Section()
            <<< ButtonRow() { $0.title = NSLocalizedString("Owner Info", comment: "Repository details user button title") }
                .onCellSelection { cell, row in viewModel.userDidSelect.on(.next())}
            +++ Section()
            <<< ButtonRow() { $0.title = NSLocalizedString("Repository details", comment: "Repository details button title") }
                .onCellSelection { cell, row in viewModel.repositoryDidSelect.on(.next())}
        
        viewModel.name.drive(onNext: { [weak self] in self?.title = $0 }).addDisposableTo(self.disposeBag)
        func bind(driver: Driver<TitleValuePair>, tag: String) {
            driver.drive(onNext: { [weak self] in self?.set($0, forTag: tag) }).addDisposableTo(self.disposeBag)
        }
        bind(driver: viewModel.language, tag: Tags.language)
        bind(driver: viewModel.createdAt, tag: Tags.createdAt)
        bind(driver: viewModel.updatedAt, tag: Tags.updatedAt)
        bind(driver: viewModel.watchersCount, tag: Tags.watchersCount)
        bind(driver: viewModel.forksCount, tag: Tags.forksCount)
        bind(driver: viewModel.openIssuesCount, tag: Tags.openIssuesCount)
        viewModel.presentUser.drive(onNext: { [weak self] viewModel in
            guard let sSelf = self else { return }
            sSelf.navigationController?.pushViewController(sSelf.toolbox.viewControllers.get(.user(viewModel)), animated: true)
        }).disposed(by: self.disposeBag)
        viewModel.presentRepository.drive(onNext: { (url: String) in
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }).disposed(by: self.disposeBag)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct Tags {
    static let name = "name"
    static let language = "language"
    static let createdAt = "createdAt"
    static let updatedAt = "updatedAt"
    static let watchersCount = "watchersCount"
    static let forksCount = "forksCount"
    static let openIssuesCount = "openIssuesCount"
}
