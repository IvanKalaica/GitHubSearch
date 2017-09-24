//
//  RepositorySearchViewController.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositorySearchViewController: UIViewController, UISearchBarDelegate {
    private let toolbox: Toolbox
    private let viewModel: RepositorySearchViewModel
    private let disposeBag = DisposeBag()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    init(toolbox: Toolbox, viewModel: RepositorySearchViewModel) {
        self.toolbox = toolbox
        self.viewModel = viewModel
        super.init(nibName: RepositorySearchViewController.className(), bundle: Bundle.main)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "RepositorySearchResultCell", bundle: nil), forCellReuseIdentifier: RepositorySearchResultCell.CellIdentifier)
        self.searchBar.placeholder = NSLocalizedString("Input repository name", comment: "Repositories section search bar placeholder")
        self.bind()
    }
    
    fileprivate func bind() {
        // MARK: - Input
        self.searchBar.rx.text.orEmpty
            .bind(to: self.viewModel.searchText)
            .disposed(by: self.disposeBag)
        
        self.searchBar.rx.selectedScopeButtonIndex
            .bind(to: self.viewModel.sort)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: self.viewModel.repositoryDidSelect)
            .disposed(by: self.disposeBag)
        
        // MARK: - Output
        self.viewModel.cellViewModels
            .bind(to: self.tableView.rx.items(cellIdentifier: RepositorySearchResultCell.CellIdentifier, cellType: RepositorySearchResultCell.self)) { [weak self] i, viewModel, cell in
                guard let sSelf = self else { return }
                cell.viewModel = viewModel
                cell.didTapSubscription?.dispose()
                cell.didTapSubscription = cell.tap.rx.event
                    .map { _ in i }
                    .bind(to: sSelf.viewModel.userDidSelect)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.presentRepository
            .drive(onNext: { [weak self] viewModel in
                guard let sSelf = self else { return }
                sSelf.navigationController?.pushViewController(sSelf.toolbox.viewControllers.get(.repository(viewModel)), animated: true)
            }).disposed(by: self.disposeBag)
        
        self.viewModel.presentUser
            .drive(onNext: { [weak self] viewModel in
                guard let sSelf = self else { return }
                sSelf.navigationController?.pushViewController(sSelf.toolbox.viewControllers.get(.user(viewModel)), animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
