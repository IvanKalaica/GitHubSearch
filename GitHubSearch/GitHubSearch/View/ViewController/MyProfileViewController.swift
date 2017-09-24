//
//  MyProfileViewController.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Eureka

class MyProfileViewController: FormViewController {
    fileprivate let disposeBag = DisposeBag()
    private let viewModel: MyProfileViewModel
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel
            .state
            .drive(onNext: { [weak self] (state: State) in
                guard let sSelf = self else { return }
                sSelf.navigationItem.rightBarButtonItem = state.buttonTitle != nil ?
                    UIBarButtonItem(title: state.buttonTitle!, style: .done, target: self, action: #selector(MyProfileViewController.logout)) : nil
                switch state {
                case .loggedIn(let viewModel):
                    let section = Section() { $0.header = HeaderFooterView<EurekaLogoView>(.class) }
                    section.tag = Tags.section
                    sSelf.form +++ section
                        <<< LabelRow(Tags.name)
                        <<< LabelRow(Tags.createdAt)
                        <<< LabelRow(Tags.company)
                        <<< LabelRow(Tags.email)
                    sSelf.set(viewModel.name, forTag: Tags.name)
                    sSelf.set(viewModel.createdAt, forTag: Tags.createdAt)
                    sSelf.set(viewModel.company, forTag: Tags.company)
                    sSelf.set(viewModel.email, forTag: Tags.email)
                    guard let view: EurekaLogoView = section.header?.viewForSection(section, type: .header) as? EurekaLogoView else { return }
                    view.imageView.load(url: viewModel.avatarUrl)
                case .loggedOut:
                    sSelf.form.removeAll()
                case .authorizing:
                    sSelf.form.removeAll()
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    func logout() {
        self.viewModel.toggleUser.onNext()
    }
}

fileprivate struct Tags {
    static let name = "name"
    static let createdAt = "createdAt"
    static let company = "company"
    static let email = "email"
    static let section = "section"
}
