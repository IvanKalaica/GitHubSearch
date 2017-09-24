//
//  UserViewController.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Eureka

class UserViewController: FormViewController {
    private let disposeBag = DisposeBag()
    
    init(viewModel: UserViewModel) {
        super.init(nibName: nil, bundle: nil)
        let section = Section() { $0.header = HeaderFooterView<EurekaLogoView>(.class) }
        section.tag = Tags.section
        self.form +++ section
            <<< LabelRow(Tags.name)
            <<< LabelRow(Tags.createdAt)
            <<< LabelRow(Tags.company)
            <<< LabelRow(Tags.email)
            +++ Section()
            <<< ButtonRow() { $0.title = NSLocalizedString("User details", comment: "User details button title") }
                .onCellSelection { cell, row in viewModel.userDidSelect.on(.next())}
        
        viewModel.username.drive(onNext: { [weak self] in self?.title = $0 }).addDisposableTo(self.disposeBag)
        viewModel.name.drive(onNext: { [weak self] in self?.set($0, forTag: Tags.name) }).addDisposableTo(self.disposeBag)
        viewModel.createdAt.drive(onNext: { [weak self] in self?.set($0, forTag: Tags.createdAt) }).addDisposableTo(self.disposeBag)
        viewModel.company.drive(onNext: { [weak self] in self?.set($0, forTag: Tags.company) }).addDisposableTo(self.disposeBag)
        viewModel.email.drive(onNext: { [weak self] in self?.set($0, forTag: Tags.email) }).addDisposableTo(self.disposeBag)
        viewModel.avatarUrl.drive(onNext: { [weak self] (avatarUrl: String) in
            guard let sSelf = self,
                let section = sSelf.form.sectionBy(tag: Tags.section),
                let view: EurekaLogoView = section.header?.viewForSection(section, type: .header) as? EurekaLogoView
                else { return }
            view.imageView.load(url: avatarUrl)
        }).addDisposableTo(self.disposeBag)
        viewModel.presentUser.drive(onNext: { (url: String) in
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
    static let createdAt = "createdAt"
    static let company = "company"
    static let email = "email"
    static let section = "section"
}
